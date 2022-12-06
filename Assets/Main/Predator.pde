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
    private int m_PreysEaten = 0;

    /* Getters/Setters. */
    public void SetHuntingPrey(Prey prey) { m_HuntingPrey = prey; }

    /*
     * Will set the state of the animal. Can NOT be forced so specific rules
     * like not changing when being controlled is active.
    */
    public void SetState(PredatorState state)
    {
        // Do not allow changing state while animal is being controlled
        if (m_State == PredatorState.POSSESED)
            return;
        
        m_State = state;
    }

    /*
     * Will set the state of the animal. Can be forced so specific rules
     * like not changing when being controlled is ignored.
    */
    public void SetState(PredatorState state, boolean force)
    {
        // Do not allow changing state while animal is being controlled
        if (m_State == PredatorState.POSSESED && !force)
            return;
        
        m_State = state;
    }

    public PredatorState GetState() { return m_State; }
    public int GetPreysEaten() { return m_PreysEaten; }

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

        m_GameObject.SetTag("Predator");
    }

    @Override
    public void Update()
    {
        // Do state specific behaviour
        switch (m_State)
        {
            case WANDERING:
                SetMovementSpeed(m_MovementSpeed);
                Wander();
                break;
            
            case HUNTING:
                Hunt(m_HuntingPrey);
                break;

            case POSSESED:
                SetMovementSpeed(m_ControlMovementSpeed);
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
    private void EatPrey(Prey prey)
    {        
        prey.Destroy();
        m_HuntingPrey = null;

        m_PreysEaten++;

        // Change state to wandering
        SetState(PredatorState.WANDERING);
    }

    @Override
    public void OnCollision(Collider collider)
    {
        // Make sure that it collided with a prey
        if (collider.GetGameObject().GetTag() != "Prey")
            return;
        
        // Eat the prey
        EatPrey((Prey) collider.GetGameObject());
    }

    @Override
    public void OnCollisionTrigger(Collider collider)
    {
        // Ignore if we hit the predator's own perimeter collider
        if (collider.GetId() == m_PerimeterCollider.GetId())
            return;
    }
}
