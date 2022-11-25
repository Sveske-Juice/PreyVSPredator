public class Prey extends Animal
{
    /* Members. */
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

        // Main Collider
        Collider collider = (Collider) AddComponent(new CircleCollider("Prey Collider", m_ColliderRadius));

        // Prey Movement behaviour
        AddComponent(new PreyController());

        // Rigidbody for physics
        AddComponent(new RigidBody());

        // Create perimeter child object
        m_BelongingToScene.AddGameObject(new PerimeterControllerObject("Perimeter Controller Object"), m_Transform);
    }
}

public class PreyController extends AnimalMover implements ITriggerEventHandler
{
    /* Members. */
    private color m_ColliderColor = color(0, 180, 0, 60);
    private int m_ClosePreysCount = 0;

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

    /* Methods. */

    @Override
    public void Start()
    {
        m_Collider = m_GameObject.GetComponent(CircleCollider.class);
        m_RigidBody = m_GameObject.GetComponent(RigidBody.class);

        // Set main collider color and collision layer
        m_Collider.SetCollisionLayer(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal());
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal()); // collide against other animals
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal()); // collide against animal's perimeter
        m_Collider.SetColor(m_ColliderColor);
    }

    @Override
    public void Update()
    {

    }

    public void OnCollisionTrigger(Collider collider, Collider colliderCalledFrom)
    {
        // If we hit our own perimeter collider, then just skip
        // NOTE: not ideal but cry about it
        // if (collider.GetId() == m_PerimeterCollider.GetId() || collider.GetId() == m_Collider.GetId())
        //     return;
        
        // // Check if the event is for the perimeter collider on this object or if its for the main collider
        // if (colliderCalledFrom.GetId() == m_PerimeterCollider.GetId())
        // {
        //     println("On Collision Trigger event raised on permmmm! with collider: " + collider.GetName());
        // }
        // else
        // {
        //     println("On Collision Trigger event raised on main! with collider: " + collider.GetName());
        
        // }
    }
}