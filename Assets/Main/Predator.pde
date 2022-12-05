/*
 * Prefab for creating a predator gameobject with it's proper components.
*/
public class Predator extends Animal
{
    /* Members. */
    private float m_ColliderRadius = 25f;


    public Predator(String name)
    {
        super(name);
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        AddComponent(new RigidBody());

        AddComponent(new PredatorController());

        AddComponent(new CircleCollider("Predator Collider", m_ColliderRadius));

        // Create perimeter child object
        m_BelongingToScene.AddGameObject(new PredatorPerimeterControllerObject("Perimeter Controller Object"), m_Transform);
    }
}

public class PredatorController extends AnimalMover implements ITriggerEventHandler
{
    /* Members. */
    private Collider m_Collider;
    private Collider m_PerimeterCollider;
    private color m_ColliderColor = color(150, 50, 0);

    @Override
    public void Start()
    {
        m_Collider = m_GameObject.GetComponent(Collider.class);
        m_Collider.SetCollisionLayer(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal());
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal()); // collide against other animals
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal()); // collide against animal's perimeter
        m_Collider.SetColor(m_ColliderColor);
        m_Collider.SetShouldDraw(true);

        // Get the perimeter collider from the child GameObject
        m_PerimeterCollider = transform().GetChild(0).GetGameObject().GetComponent(CircleCollider.class);
    }


    public void OnCollisionTrigger(Collider collider)
    {
        // Ignore if we hit the predator's own perimeter collider
        if (collider.GetId() == m_PerimeterCollider.GetId())
            return;
        
        // println("Prey main collider triggered with: " + collider.GetName());
    }
}
