public abstract class Collider extends Component
{
    /* Members. */
    protected color m_OnCollisionColor = color(255, 0, 0);

    protected boolean m_IsTrigger = false;
    protected boolean m_IsDynamic = true;

    /* Getters/Setters. */
    public boolean IsTrigger() { return m_IsTrigger; }
    public boolean IsDynamic() { return m_IsDynamic; }

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
        fill(150, 0, 0, 75);
        DrawCollider();
        fill(255);
    }

    public abstract void DrawCollider();

    // Double dispatch runtime check of collider type to concrete class
    public abstract CollisionPoint TestCollision(Collider collider);

    public abstract CollisionPoint TestCollision(BoxCollider collider);
    public abstract CollisionPoint TestCollision(CircleCollider collider);
}