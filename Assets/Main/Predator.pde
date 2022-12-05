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

public class PredatorController extends AnimalMover implements ITriggerEventHandler, ICollisionEventHandler
{
    /* Members. */
    private Collider m_Collider;
    private Collider m_PerimeterCollider;
    private color m_ColliderColor = color(150, 50, 0);
    private PredatorState m_State = PredatorState.WANDERING;
    private Prey m_HuntingPrey;

    /* Getters/Setters. */
    public void SetHuntingPrey(Prey prey) { m_HuntingPrey = prey; }
    public void SetState(PredatorState state) { m_State = state; }

    @Override
    public void Start()
    {
        super.Start();

        m_Collider = m_GameObject.GetComponent(Collider.class);
        m_Collider.SetCollisionLayer(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal());
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal()); // collide against other animals
        m_Collider.GetCollisionMask().SetBit(CollisionLayer.ANIMAL_PEREMITER_COLLIDER.ordinal()); // collide against animal's perimeter
        m_Collider.SetColor(m_ColliderColor);
        m_Collider.SetShouldDraw(true);

        // Get the perimeter collider from the child GameObject
        m_PerimeterCollider = transform().GetChild(0).GetGameObject().GetComponent(CircleCollider.class);
    }

    @Override
    public void Update()
    {
        // Do state specific behaviour
        switch (m_State)
        {
            case WANDERING:
                Wander();
                break;
            
            case HUNTING:
                Hunt(m_HuntingPrey);
                break;

            default:
                break;
        }
    }

    /*
     * Will be called every frame the predator is in the hunting state of the FSM.
     * This method will handle hunting the prey (moving towards).
    */
    private void Hunt(Prey prey)
    {
        // Get the position of the prey
        ZVector preyPos = prey.GetTransform().GetPosition();

        // Create vector from predator to prey
        ZVector directionToPrey = ZVector.sub(preyPos, transform().GetPosition());

        directionToPrey.normalize();

        Move(directionToPrey);
    }

    /*
     * Will handle eating the prey currently hunting (m_HuntingPrey)
    */
    private void EatPrey()
    {
        if (m_HuntingPrey == null)
            return;
        
        m_HuntingPrey.Destroy();
        m_HuntingPrey = null;

        // Change state to wandering
        m_State = PredatorState.WANDERING;
    }

    @Override
    public void OnCollision(Collider collider)
    {
        // Make sure that it collided with a prey
        if (collider.GetGameObject().GetTag() != "Prey")
            return;
        
        // Eat the prey
        EatPrey();
    }

    @Override
    public void OnCollisionTrigger(Collider collider)
    {
        // Ignore if we hit the predator's own perimeter collider
        if (collider.GetId() == m_PerimeterCollider.GetId())
            return;
    }
}
