public class Prey extends Animal
{
    /* Members. */
    private float m_ViewRadius = 200f;
    private float m_ColliderRadius = 25f;
    private color m_ColliderColor = color(0, 180, 0, 60);
    private color m_ViewPerimeterColliderColor = color(50, 50, 50, 20);

    private Collider m_PeremiterCollider;
    private Collider m_Collider;


    public Prey(String name)
    {
        super(name);
    }
    
    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        // Create and set main collider color
        m_Collider = (Collider) AddComponent(new CircleCollider("Prey Collider", m_ColliderRadius));
        m_Collider.SetCollisionLayer(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal());
        m_Collider.SetColor(m_ColliderColor);

        // Create and set view perimeter collider color
        m_PeremiterCollider = (Collider) AddComponent(new CircleCollider("Prey Detect Perimeter", m_ViewRadius));
        m_PeremiterCollider.SetCollisionLayer(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal());
        m_PeremiterCollider.SetTrigger(true);
        m_PeremiterCollider.SetColor(m_ViewPerimeterColliderColor);

        // Prey Movement behaviour
        AddComponent(new PreyMover());
    }
}

public class PreyMover extends AnimalMover implements ITriggerEventHandler
{
    /* Members. */
    private RigidBody m_RB;

    /* Constructors. */

    // Default constructor, use default movement speed
    public PreyMover()
    {
        m_Name = "Prey Mover";
    }

    // Specify movement speed
    public PreyMover(float moveSpeed)
    {
        m_MovementSpeed = moveSpeed;
        m_Name = "Prey Mover";
    }

    /* Methods. */

    @Override
    public void Start()
    {
        m_RB = m_GameObject.GetComponent(RigidBody.class);
    }

    @Override
    public void Update()
    {

    }

    public void OnCollisionTrigger(Collider collider)
    {
        println("On Collision Trigger event raised! with gameObject: " + collider.GetGameObject().GetName());
        // m_GameObject.GetComponent(Collider.class).SetColor(color(0, 200, 0, 75));
    }
}