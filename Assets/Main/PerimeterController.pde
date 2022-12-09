public class PreyPerimeterControllerObject extends GameObject
{
    /* Members. */
    private float m_ViewRadius = 200f;

    public PreyPerimeterControllerObject(String name)
    {
        super(name);
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        AddComponent(new CircleCollider("Prey Detect Perimeter", m_ViewRadius));

        AddComponent(new PreyPerimeterController());
    }
}

public class PredatorPerimeterControllerObject extends GameObject
{
    /* Members. */
    private float m_ViewRadius = 200f;

    public PredatorPerimeterControllerObject(String name)
    {
        super(name);
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        AddComponent(new CircleCollider("Predator Detect Perimeter", m_ViewRadius));

        AddComponent(new PredatorPerimeterController());
    }
}

public class PreyPerimeterController extends Component implements ITriggerEventHandler
{
    private GameObject m_Prey; // The Prey associated with this PerimeterController
    private PreyController m_PreyController;
    private Collider m_PreyMainCollider;
    private Collider m_Collider;
    private color m_ViewPerimeterColliderColor = color(50, 50, 50);

    @Override
    public void Start()
    {
        m_Prey = transform().GetParent().GetGameObject();
        m_PreyController = m_Prey.GetComponent(PreyController.class);
        m_PreyMainCollider = m_Prey.GetComponent(Collider.class);

        // Set view perimeter collider color and collision layer
        m_Collider = m_GameObject.GetComponent(Collider.class);
        m_Collider.SetTickEveryFrame(60); // Check for collision on perimeter collider very 20th frame
        m_Collider.SetCollisionLayer(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal());
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal()); // collide against animals
        m_Collider.SetTrigger(true);
        m_Collider.SetColor(m_ViewPerimeterColliderColor);
        m_Collider.SetStroke(true);
        m_Collider.SetFill(false);
        m_GameObject.SetTag("Perimeter");
    }

    public void OnCollisionTrigger(Collider collider)
    {
        // Do not do anything when it was triggered with the main prey collider
        if (m_PreyMainCollider.GetId() == collider.GetId())
            return;

        // If the perimeter triggered with a prey
        if (collider.GetGameObject().GetTag() == "Prey")
        {
            // Update so PreyController knows that there are a prey nearby
            m_PreyController.SetNearbyPreys(m_PreyController.GetNearbyPreys() + 1);
        }
    }
}


public class PredatorPerimeterController extends Component implements ITriggerEventHandler
{
    private PredatorController m_Predator;
    private Collider m_Collider;
    private Collider m_PredatorMainCollider;
    private color m_ViewPerimeterColliderColor = color(0, 0, 0);

    @Override
    public void Start()
    {
        m_Predator = transform().GetParent().GetGameObject().GetComponent(PredatorController.class);

        // Set view perimeter collider color and collision layer
        m_Collider = m_GameObject.GetComponent(Collider.class);
        m_Collider.SetTickEveryFrame(20); // Check for collision on perimeter collider very 20th frame
        m_Collider.SetCollisionLayer(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal());
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal()); // collide against animals
        m_Collider.SetTrigger(true);
        m_Collider.SetColor(m_ViewPerimeterColliderColor);
        m_Collider.SetStroke(true);
        m_Collider.SetFill(false);
        m_GameObject.SetTag("Perimeter");

        m_PredatorMainCollider = m_Predator.GetGameObject().GetComponent(Collider.class);
    }


    public void OnCollisionTrigger(Collider collider)
    {
        // Do not do anything when it was triggered with the main predator collider
        if (m_PredatorMainCollider.GetId() == collider.GetId())
            return;

        // If the perimeter triggered with a prey
        if (collider.GetGameObject().GetTag() == "Prey")
        {
            // Set the prey the predator will hunt
            m_Predator.SetHuntingPrey((Prey) collider.GetGameObject());

            // Update the predator's state
            m_Predator.SetState(PredatorState.HUNTING);

            m_Predator.SetNearbyPreys(m_Predator.GetNearbyPreys() + 1);
        }
    }
}