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
    protected Scene m_Scene;
    protected Polygon m_Polygon;
    protected float m_MovementSpeed = 125f;
    private float m_CurrentMovementSpeed;
    protected float m_ControlMovementSpeed = 400f;
    protected RigidBody m_RigidBody;
    protected float m_WanderRadius = 50f; // How much the radius of the wandering is
    protected float m_WanderDirectionExtend = 200f; // How much of the animal's direction (v) will be extended when wandering
    protected boolean m_ShowWandererInfo = false;

    /* Getters/Setters. */
    public float GetMovementSpeed() { return m_CurrentMovementSpeed; }
    public void ShowWanderInfo() { m_ShowWandererInfo = true; }
    public void HideWanderInfo() { m_ShowWandererInfo = false; }
    public void SetMovementSpeed(float value) { m_CurrentMovementSpeed = value; m_RigidBody.SetMaxSpeed(value); }

    /* Methods. */

    @Override
    public void Start()
    {
        m_Scene = m_GameObject.GetBelongingToScene();
        m_RigidBody = m_GameObject.GetComponent(RigidBody.class);
        m_Polygon = m_GameObject.GetComponent(Polygon.class);
        m_Polygon.SetRotationOffset(0);
    }

    @Override
    public void Exit()
    {
        // Register a animal death
        m_Scene.FindGameObject("Animal Event Initiator Handler").GetComponent(AnimalEventInitiator.class).RegisterAnimalDeath((Animal) m_GameObject, m_GameObject.GetId());
    }

    @Override
    public void Update()
    {
        // Rotate animal in its movement direction
        // println("angle: " + m_RigidBody.GetVelocity().angle());
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
        float speed = m_RigidBody.GetVelocity().mag();

        // Generate polar coordinates from a circle to constrain the animals movement to it's velocity
        float angle = random(0, 1) * 2 * PI;
        ZVector wanderedPos = nextPos.copy();
        wanderedPos.x += m_WanderRadius * cos(angle); // Convert to cartesian
        wanderedPos.y += m_WanderRadius * sin(angle); // Convert to cartesian

        if (m_ShowWandererInfo) // Show debug information
        {
            noFill();
            stroke(0);
            circle(nextPos.x, nextPos.y, m_WanderRadius*2);
            
            fill(255, 0, 0);
            circle(wanderedPos.x, wanderedPos.y, 15);
        }

        // Set new velocity
        // m_RigidBody.SetVelocity(ZVector.sub(wanderedPos, transform().GetPosition()).normalize().mult(m_CurrentMovementSpeed));
        // Move(ZVector.sub(wanderedPos, transform().GetPosition()).normalize());
        m_RigidBody.ApplyForce(ZVector.sub(wanderedPos, transform().GetPosition()).normalize().mult(speed+1));
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
