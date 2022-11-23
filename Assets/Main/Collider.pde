public abstract class Collider extends Component
{
    /* Members. */
    protected color m_ColliderColor = color(150, 0, 0, 75);

    protected boolean m_IsTrigger = false;

    /* Getters/Setters. */
    public boolean IsTrigger() { return m_IsTrigger; }
    public void SetTrigger(boolean value) { m_IsTrigger = value; }

    public void SetColor(color _color) { m_ColliderColor = _color; }

    /* Constructors. */

    public Collider(String name)
    {
        m_Name = name;
    }
    
    /* Methods. */
    @Override
    public void Start()
    {
        //m_GameObject.GetBelongingToScene().GetCollissionSystem().RegisterCollider(this);
        m_GameObject.GetBelongingToScene().GetPhysicsSystem().RegisterCollider(this);
    }

    @Override
    public void Update()
    {
        fill(m_ColliderColor);
        DrawCollider();
        fill(255);
    }

    public abstract void DrawCollider();

    // Double dispatch runtime check of collider type to concrete class
    public abstract CollisionPoint TestCollision(Collider collider);

    public abstract CollisionPoint TestCollision(BoxCollider collider);
    public abstract CollisionPoint TestCollision(CircleCollider collider);

    // Clamps a value between a range
    protected float Clamp(float value, float min, float max)
    {
        return max(min, min(max, value));
    }

    public abstract PVector GetMinExtents();
    public abstract PVector GetMaxExtents();

    public abstract RaycastHit TestRaycast(Ray ray);
}