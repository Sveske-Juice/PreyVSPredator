public abstract class Animal extends GameObject 
{    
    public Animal(String name)
    {
        super(name);
    }
}

public class AnimalMover extends Component
{
    /* Members. */
    protected GameScene m_GameScene;
    protected Polygon m_Polygon;
    protected float m_SpeedMultiplier = 1f;
    private float m_CurrentMovementSpeed;
    protected float m_ControlMovementSpeed = 400f;
    protected RigidBody m_RigidBody;
    protected float m_WanderRadius = 50f; // How much the radius of the wandering is
    protected float m_WanderAngleChange = 0.5f;
    protected float m_WanderAngle = 0f;
    protected float m_WanderDirectionExtend = 100f; // How much of the animal's direction (v) will be extended when wandering
    protected boolean m_ShowWandererInfo = false;

    /* Getters/Setters. */
    public float GetMovementSpeed() { return m_CurrentMovementSpeed; }
    public void ShowWanderInfo() { m_ShowWandererInfo = true; }
    public void HideWanderInfo() { m_ShowWandererInfo = false; }
    public void SetMovementSpeed(float value) { m_CurrentMovementSpeed = value * m_SpeedMultiplier; m_RigidBody.SetMaxSpeed(value * m_SpeedMultiplier); }
    public float GetSpeedMultiplier() { return m_SpeedMultiplier; }
    public void SetSpeedMultiplier(float value) { m_SpeedMultiplier = value; }

    /* Methods. */

    @Override
    public void Start()
    {
        m_GameScene = (GameScene) m_GameObject.GetBelongingToScene();
        m_RigidBody = m_GameObject.GetComponent(RigidBody.class);
        m_Polygon = m_GameObject.GetComponent(Polygon.class);
        m_Polygon.SetRotationOffset(0);
    }

    @Override
    public void Exit()
    {
        // Register a animal death
        m_GameScene.FindGameObject("Animal Event Initiator Handler").GetComponent(AnimalEventInitiator.class).RegisterAnimalDeath((Animal) m_GameObject, m_GameObject.GetId());
    }

    @Override
    public void Update()
    {
        // Rotate animal in its movement direction
        m_GameObject.GetTransform().SetRotation(m_RigidBody.GetVelocity().copy().normalize().angle());
    }
    
    /*
     * Will be called every frame the animal is in the wandering state of the FSM.
     * This method will handle wandering of the animal.
    */
    protected void Wander()
    {
        // Get a position scaled by 'm_WanderDirectionExtend' in the animal's movement direction
        ZVector nextPos = ZVector.add(transform().GetPosition(), ZVector.mult(m_RigidBody.GetVelocity().copy().normalize(), m_WanderDirectionExtend));

        // Generate polar coordinates from a circle to constrain the animals movement to it's velocity
        m_WanderAngle += random(-m_WanderAngleChange, m_WanderAngleChange);
        ZVector wanderedPos = nextPos.copy();
        wanderedPos.x += m_WanderRadius * cos(m_WanderAngle); // Convert to cartesian
        wanderedPos.y += m_WanderRadius * sin(m_WanderAngle); // Convert to cartesian

        if (m_ShowWandererInfo) // Show debug information
        {
            ZVector pos = transform().GetPosition();
            line(pos.x, pos.y, nextPos.x, nextPos.y);

            noFill();
            stroke(0);
            circle(nextPos.x, nextPos.y, m_WanderRadius*2);
            
            line(nextPos.x, nextPos.y, wanderedPos.x, wanderedPos.y);

            fill(0);
            circle(wanderedPos.x, wanderedPos.y, 10f);
        }

        // Apply force in new wander direction
        m_RigidBody.ApplyForce(ZVector.sub(wanderedPos, transform().GetPosition()).normalize().mult(m_CurrentMovementSpeed));
    }

    /*
     * Will move the animal in a direction specified by 'direction'.
     * The speed will in which the animal will move is specified by
     * 'm_MovementSpeed'.
    */
    protected void Move(ZVector direction)
    {
        m_RigidBody.ApplyForce(direction.copy().normalize().mult(m_CurrentMovementSpeed));
    }
}
