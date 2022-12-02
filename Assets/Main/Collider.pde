public abstract class Collider extends Component implements IQuadTreeEntity
{
    /* Members. */
    protected color m_ColliderColor = color(150, 0, 0, 75);

    // The layers this collider interacts with
    protected BitField m_CollisionMask = new BitField();


    // The layer this collider is on
    protected int m_CollisionLayer = CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal(); // Default to being the main collider of an Animal
    protected boolean m_IsTrigger = false;
    protected boolean m_ShouldFill = true;
    protected boolean m_ShouldStroke = false;
    protected boolean m_ShouldDraw = false;

    /* Getters/Setters. */
    public boolean IsTrigger() { return m_IsTrigger; }
    public void SetTrigger(boolean value) { m_IsTrigger = value; }
    public void SetCollisionLayer(int layer) { m_CollisionLayer = layer; }
    public int GetCollisionLayer() { return m_CollisionLayer; }
    public BitField GetCollisionMask() { return m_CollisionMask; }
    public void SetColor(color _color) { m_ColliderColor = _color; }
    public void SetFill(boolean value) { m_ShouldFill = value; }
    public void SetStroke(boolean value) { m_ShouldStroke = value; }
    public void SetShouldDraw(boolean value) { m_ShouldDraw = value; }
    public abstract ZVector GetCenter();
    public ZVector GetPosition() { return transform().GetPosition(); }

    /* Constructors. */

    public Collider(String name)
    {
        m_Name = name;
    }
    
    /* Methods. */
    @Override
    public void Start()
    {
        m_GameObject.GetBelongingToScene().GetPhysicsSystem().RegisterCollider(this);        
    }

    @Override
    public void Update()
    {
        if (!m_ShouldDraw)
            return;
        
        if (m_ShouldFill)
            fill(m_ColliderColor);
        else
            noFill();

        if (m_ShouldStroke)
            stroke(color(0, 0, 0));
        else
            noStroke();

        DrawCollider();
    }

    public abstract void DrawCollider();

    // Double dispatch runtime check of collider type to concrete collider class
    public abstract CollisionPoint TestCollision(Collider collider);

    public abstract CollisionPoint TestCollision(BoxCollider collider);
    public abstract CollisionPoint TestCollision(CircleCollider collider);

    public abstract boolean PointInCollider(ZVector point);

    // Clamps a value between a range
    protected float Clamp(float value, float min, float max)
    {
        return max(min, min(max, value));
    }

    public abstract ZVector GetMinExtents();
    public abstract ZVector GetMaxExtents();

    public abstract RaycastHit TestRaycast(Ray ray);
}