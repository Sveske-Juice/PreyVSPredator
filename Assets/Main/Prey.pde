public class Prey extends Animal
{
    /* Members. */
    private float m_ViewRadius = 200f;
    private float m_ColliderRadius = 25f;

    /* Getters/Setters. */

    public Prey(String name)
    {
        super(name);
    }
    
    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        // Colliders
        Collider collider = (Collider) AddComponent(new CircleCollider("Prey Collider", m_ColliderRadius));
        Collider perimeterCollider = (Collider) AddComponent(new CircleCollider("Prey Detect Perimeter", m_ViewRadius));

        // Prey Movement behaviour
        AddComponent(new PreyController(collider, perimeterCollider));

        // Rigidbody for physics
        AddComponent(new RigidBody());
    }
}

public class PreyController extends AnimalMover implements ITriggerEventHandler
{
    /* Members. */
    private color m_ColliderColor = color(0, 180, 0, 60);
    private color m_ViewPerimeterColliderColor = color(50, 50, 50, 20);

    private Collider m_PerimeterCollider;
    private Collider m_Collider;
    private RigidBody m_RigidBody;

    /* Constructors. */

    // Default constructor, use default movement speed
    public PreyController()
    {
        m_Name = "Prey Mover";
    }

    // Specify movement speed
    public PreyController(float moveSpeed)
    {
        m_MovementSpeed = moveSpeed;
        m_Name = "Prey Mover";
    }

    public PreyController(Collider mainCollider, Collider perimeterCollider)
    {
        m_Collider = mainCollider;
        m_PerimeterCollider = perimeterCollider;
    }

    /* Methods. */

    @Override
    public void Start()
    {
        m_RigidBody = m_GameObject.GetComponent(RigidBody.class);

        // Set main collider color and collision layer
        m_Collider.SetCollisionLayer(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal());
        m_Collider.SetColor(m_ColliderColor);

        // Set view perimeter collider color and collision layer
        m_PerimeterCollider.SetCollisionLayer(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal());
        m_PerimeterCollider.SetTrigger(true);
        m_PerimeterCollider.SetColor(m_ViewPerimeterColliderColor);
    }

    @Override
    public void Update()
    {

    }

    public void OnCollisionTrigger(Collider collider, Collider colliderCalledFrom)
    {
        // If we hit our own perimeter collider, then just skip
        // NOTE: not ideal but cry about it
        if (collider.GetId() == m_PerimeterCollider.GetId() || collider.GetId() == m_Collider.GetId())
            return;
        
        // Check if the event is for the perimeter collider on this object or if its for the main collider
        if (colliderCalledFrom.GetId() == m_PerimeterCollider.GetId())
        {
            println("On Collision Trigger event raised on permmmm! with collider: " + collider.GetName());
        }
        else
        {
        
        }
        // m_GameObject.GetComponent(Collider.class).SetColor(color(0, 200, 0, 75));
    }
}