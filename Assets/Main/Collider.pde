public abstract class Collider extends Component
{
    /* Members. */
    protected color m_ColliderColor = color(150, 0, 0, 75);
    protected int m_FramesSinceTick = 0; // Counter variable for counting how many frames since the collider was checked for collision
    protected int m_TickEveryFrame = 0; // Variable specifying how many frames should go after checking the collider again, default 1 (every frame)


    // The layers this collider interacts with
    protected BitField m_CollisionMask = new BitField();

    // The layer this collider is on
    protected int m_CollisionLayer = CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal(); // Default to being the main collider of an Animal

    protected boolean m_IsTrigger = false; // Is a trigger collider - collision won't physically be resolved
    protected boolean m_ShouldFill = true; // should fill when drawing collider
    protected boolean m_ShouldStroke = false; // should stroke when drawing collider
    protected boolean m_ShouldDraw = false; // should draw collider

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
    public int GetFramesSinceTick() { return m_FramesSinceTick; }
    public void SetFramesSinceTick(int value) { m_FramesSinceTick = value; }
    public int GetTickEveryFrame() { return m_TickEveryFrame; }
    public void SetTickEveryFrame(int value) { m_TickEveryFrame = value; }
    public abstract ZVector GetCenter();

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

    public String toString()
    {
        return m_Name;
    }
}