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

public class PerimeterController extends Component
{
    private Collider m_PerimeterCollider;
    private color m_ViewPerimeterColliderColor = color(50, 50, 50, 20);

    @Override
    public void Start()
    {
        // Set view perimeter collider color and collision layer
        m_PerimeterCollider = m_GameObject.GetComponent(Collider.class);
        m_PerimeterCollider.SetCollisionLayer(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal());
        m_PerimeterCollider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal()); // collide against animals
        m_PerimeterCollider.SetTrigger(true);
        m_PerimeterCollider.SetColor(m_ViewPerimeterColliderColor);
    }

    @Override
    public void Update()
    {
        // println("parent: " + transform().GetParent().GetGameObject().GetName());
    }
}