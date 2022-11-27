public class PerimeterControllerObject extends GameObject
{
    /* Members. */
    private float m_ViewRadius = 200f;

    public PerimeterControllerObject(String name)
    {
        super(name);
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        AddComponent(new CircleCollider("Prey Detect Perimeter", m_ViewRadius));

        AddComponent(new PerimeterController());
    }
}

public class PerimeterController extends Component implements ITriggerEventHandler
{
    private GameObject m_Prey; // The Prey associated with this PerimeterController
    private PreyController m_PreyController;
    private Collider m_PreyMainCollider;
    private Collider m_Collider;
    private color m_ViewPerimeterColliderColor = color(50, 50, 50, 20);

    @Override
    public void Start()
    {
        m_Prey = transform().GetParent().GetGameObject();
        m_PreyController = m_Prey.GetComponent(PreyController.class);
        m_PreyMainCollider = m_Prey.GetComponent(Collider.class);

        // Set view perimeter collider color and collision layer
        m_Collider = m_GameObject.GetComponent(Collider.class);
        m_Collider.SetCollisionLayer(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal());
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal()); // collide against animals
        m_Collider.SetTrigger(true);
        m_Collider.SetColor(m_ViewPerimeterColliderColor);
        
        m_GameObject.SetTag("Perimeter");
    }

    @Override
    public void Update()
    {
        // println("components: " + m_GameObject.GetComponents());
        // println("parent: " + transform().GetParent().GetGameObject().GetName());
        CircleCollider collider = (CircleCollider) m_GameObject.GetComponent(CircleCollider.class);
        
        if (collider != null)
        {
            if (InputManager.GetInstance().GetKey(38)) // up arrow
                collider.SetRadius(collider.GetRadius() + 0.5);
            else if (InputManager.GetInstance().GetKey(40)) // dwn arrow
                collider.SetRadius(collider.GetRadius() - 0.5);
        }
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
        
        // println("Perimeter controller: triggered with: " + collider.GetName() + " on obj: " + collider.GetGameObject().GetName());
    }
}