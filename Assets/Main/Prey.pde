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
        AddComponent(new CircleCollider("Prey Collider", m_ColliderRadius));

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
    private Collider m_PerimeterCollider;
    private RigidBody m_RigidBody;

    private int m_NearbyPreys = 0;
    private int m_MaxNumOfPreys = 3;
    private float m_SplitTime = 60f; // Amount when a prey should split
    private float m_CurrentSplit = 0f; // Current value counter for split

    /* Getters/Setters. */
    public void SetNearbyPreys(int value) { m_NearbyPreys = value; }
    public int GetNearbyPreys() { return m_NearbyPreys; }
    public float GetSplitTime() { return m_SplitTime; }
    public float GetCurrentSplitTime() { return m_CurrentSplit; }

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
        // Get the perimeter collider from the child GameObject
        m_PerimeterCollider = transform().GetChild(0).GetGameObject().GetComponent(Collider.class);

        m_Collider = m_GameObject.GetComponent(Collider.class);
        m_RigidBody = m_GameObject.GetComponent(RigidBody.class);

        // Set main collider color and collision layer
        m_Collider.SetCollisionLayer(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal());
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal()); // collide against other animals
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal()); // collide against animal's perimeter
        m_Collider.SetColor(m_ColliderColor);
        
        m_GameObject.SetTag("Prey");
    }

    @Override
    public void Update()
    {
        // Increment current split time with dt and the number of preys as a grow factor
        if (m_NearbyPreys >= m_MaxNumOfPreys) m_NearbyPreys = m_MaxNumOfPreys; // Limit growth factor to avoid explosion in splitting

        m_CurrentSplit += Time.dt() * (m_NearbyPreys + 1);

        // If current counter has reached the time requeried for a split then split the prey
        if (m_CurrentSplit >= m_SplitTime)
        {
            SplitPrey();
            m_CurrentSplit = 0f;
        }

        // Physics system is updated later than components so no more
        // preys will be spotted this frame and its safe to reset for next frame
        m_NearbyPreys = 0;
    }

    private void SplitPrey()
    {
        Prey newPrey = (Prey) m_GameObject.GetBelongingToScene().AddGameObject(new Prey("Prey (child of " + m_GameObject.GetName() + ")"));
        newPrey.GetTransform().SetPosition(m_Collider.GetMaxExtents());
    }

    public void OnCollisionTrigger(Collider collider)
    {
        // Ignore if we hit the prey's perimeter collider
        if (collider.GetId() == m_PerimeterCollider.GetId())
            return;
        
        // println("Prey main collider triggered with: " + collider.GetName());
    }
}