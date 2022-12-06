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
    private CircleCollider m_PerimeterCollider;
    private color m_ColliderColor = color(150, 50, 0);
    private PredatorState m_State = PredatorState.WANDERING;
    private Prey m_HuntingPrey;
    private int m_PreysEaten = 0;
    private float m_MaxNutrients = 100f; // Max nutrient level of predator
    private float m_Nutrients = m_MaxNutrients / 2f; // Current nutrients, starts out being half of max
    private float m_SplitNutrientPercentage = 0.8f; // Percentage required for split
    private float m_NutrientsGainedWhenEating = 0.1f; // Percentage nutrient gain when eating prey
    private float m_NutrientDropWhenSplit = 0.75f; // Nutrient percentage dropped when predator split

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
    public float GetNutrients() { return m_Nutrients; }
    public float GetMaxNutrients() { return m_MaxNutrients; }

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
        // Make predator hungry
        m_Nutrients -= Time.dt();
        
        // Split predator if have enough nutrients
        if ((m_Nutrients / m_MaxNutrients) >= m_SplitNutrientPercentage)
        {
            SplitPredator();
        }

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

        // Give nutrients
        m_Nutrients += m_MaxNutrients * m_NutrientsGainedWhenEating;

        // Change state to wandering
        SetState(PredatorState.WANDERING);
    }

    /*
     * Will split the predator.
    */
    private void SplitPredator()
    {
        ZVector newPredatorPos = new ZVector();

        // Generate a random polar coordinat inside the preys perimeter
        float R = m_PerimeterCollider.GetRadius();
        float r = R * sqrt(random(0, 1)); // New random radius (first component of polar coordinate)
        float angle = random(0, 1) * 2 * PI; // Get the random angle (second component of polar coordinate)

        // Convert to cartesian coordinate
        newPredatorPos.x = m_Collider.transform().GetPosition().x + r * cos(angle);
        newPredatorPos.y = m_Collider.transform().GetPosition().y + r * sin(angle);

        Predator newPrey = (Predator) m_GameObject.GetBelongingToScene().AddGameObject(new Predator("Predator"), newPredatorPos);

        // TODO use observer pattern
        m_Scene.SetCurrentPredatorCount(m_Scene.GetCurrentPredatorCount() + 1);

        // Drop nutrients
        m_Nutrients -= m_MaxNutrients * m_NutrientDropWhenSplit;
        if (m_Nutrients < 0) m_Nutrients = 0; // Clamp to be positive
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
