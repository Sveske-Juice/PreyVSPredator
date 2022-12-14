/*
 * Prefab for creating a prey gameobject with it's proper components.
*/
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
        m_BelongingToScene.AddGameObject(new PreyPerimeterControllerObject("Perimeter Controller Object"), m_Transform);

        // Create shape
        AddComponent(new Polygon(loadShape("prey.svg")));
    }
}

public class PreyController extends AnimalMover implements ITriggerEventHandler
{
    /* Members. */
    private color m_ColliderColor = color(0, 180, 0);
    private int m_ClosePreysCount = 0;
    private PreyState m_State = PreyState.WANDERING;

    private Collider m_Collider;
    private CircleCollider m_PerimeterCollider;
    private RigidBody m_RigidBody;

    private int m_NearbyPreys = 0; // How many preys are within this prey's view (perimiter)
    private int m_SplitMultiplier = 0; // Current split multiplier
    private int m_MaxSplitMultiplier = 3; // Do not increase split multiplier more than this
    private int m_MaxNearbyPreysToSplit = 15; // Do not split if there are more than m_MaxNearbyPreysToSplit preys nearby
    private float m_CurrentSplit = 0f; // Current value counter for split

    /* Getters/Setters. */
    public void SetNearbyPreys(int value) { m_NearbyPreys = value; }
    public int GetNearbyPreys() { return m_NearbyPreys; }
    public int GetMaxNearbyPreys() { return m_MaxNearbyPreysToSplit; }
    public int GetSplitMultiplier() { return m_SplitMultiplier; }
    public float GetCurrentSplitTime() { return m_CurrentSplit; }
    public void SetState(PreyState state) { m_State = state; }
    public PreyState GetState() { return m_State; }

    /* Constructors. */

    // Default constructor, use default movement speed
    public PreyController()
    {
        m_Name = "Prey Mover";
    }

    /* Methods. */

    @Override
    public void Start()
    {
        super.Start();

        // Get the perimeter collider from the child GameObject
        m_PerimeterCollider = transform().GetChild(0).GetGameObject().GetComponent(CircleCollider.class);

        m_Collider = m_GameObject.GetComponent(Collider.class);
        m_RigidBody = m_GameObject.GetComponent(RigidBody.class);

        // Set main collider color and collision layer
        m_Collider.SetCollisionLayer(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal());
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal()); // collide against other animals
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal()); // collide against animal's perimeter
        m_Collider.SetColor(m_ColliderColor);
        // m_Collider.SetShouldDraw(true);
        // m_Collider.SetFill(true);
        m_Collider.SetStroke(true);
        
        m_GameObject.SetTag("Prey");
    }

    @Override
    public void Update()
    {
        super.Update();
        
        if (m_NearbyPreys >= m_MaxSplitMultiplier) 
            m_SplitMultiplier = m_MaxSplitMultiplier; // Limit growth factor to avoid explosion in splitting
        else
            m_SplitMultiplier = m_NearbyPreys;

        // Increment current split time with dt if the max number of preys aren't met yet and there's room for the new prey
        if (m_GameScene.GetGameSettings().GetCurrentPreyCount() < m_GameScene.GetGameSettings().GetMaxPreyCount()  && m_NearbyPreys < m_MaxNearbyPreysToSplit)
            m_CurrentSplit += Time.dt() * (m_SplitMultiplier + 1);

        // If current counter has reached the time requeried for a split 
        if (m_CurrentSplit >= m_GameScene.GetGameSettings().GetPreySplitTime())
        {
            SplitPrey();
            m_CurrentSplit = 0f;
        }

        switch(m_State)
        {
            case WANDERING:
                SetMovementSpeed(m_GameScene.GetGameSettings().GetAnimalMovementSpeed());
                Wander();
                break;

            case GATHERING:
                Gather();
                break;

            case POSSESED:
                SetMovementSpeed(m_ControlMovementSpeed);
                break;
            
            default:
                break;
        }

        // Physics system is updated later than components so no more
        // preys will be spotted this frame and its safe to reset for next frame
        if (m_PerimeterCollider.GetFramesSinceTick() == m_PerimeterCollider.GetTickEveryFrame()) // Make sure the perimiter collider will be ticked next frame
            m_NearbyPreys = 0;
    }

    private void Gather()
    {

    }

    private void SplitPrey()
    {
        ZVector newPreyPos = new ZVector();

        // Generate a random polar coordinat inside the preys perimeter
        float R = m_PerimeterCollider.GetRadius();
        float r = R * sqrt(random(0, 1)); // New random radius (first component of polar coordinate)
        float angle = random(0, 1) * 2 * PI; // Get the random angle (second component of polar coordinate)

        // Convert to cartesian coordinate
        newPreyPos.x = m_Collider.transform().GetPosition().x + r * cos(angle);
        newPreyPos.y = m_Collider.transform().GetPosition().y + r * sin(angle);
        
        Prey newPrey = (Prey) m_GameObject.GetBelongingToScene().AddGameObject(new Prey("Prey"), newPreyPos);

        // TODO use observer pattern
        m_GameScene.GetGameSettings().SetCurrentPreyCount(m_GameScene.GetGameSettings().GetCurrentPreyCount() + 1);
    }

    @Override
    public void OnCollisionTrigger(Collider collider)
    {
        // Ignore if we hit the prey's perimeter collider
        if (collider.GetId() == m_PerimeterCollider.GetId())
            return;

    }

    @Override
    public void Exit()
    {
        super.Exit();

        // Decrease prey counter
        m_GameScene.GetGameSettings().SetCurrentPreyCount(m_GameScene.GetGameSettings().GetCurrentPreyCount() - 1);
    }
}