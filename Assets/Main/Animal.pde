public abstract class Animal extends GameObject 
{    
    public Animal(String name)
    {
        super(name);
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();
        
        AddComponent(new Polygon(createShape(RECT, 2, 2, 10, 10)));
    }
}

public class AnimalMover extends Component
{
    /* Members. */
    protected float m_MovementSpeed = 100f;
    protected RigidBody m_RigidBody;
    protected float m_WanderRadius = 50f; // How much the radius of the wandering is
    protected float m_WanderDirectionExtend = 200f; // How much of the animal's direction (v) will be extended when wandering
    protected boolean m_ShowWandererInfo = false;

    /* Getters/Setters. */
    public float GetMovementSpeed() { return m_MovementSpeed; }
    public void ShowWanderInfo() { m_ShowWandererInfo = true; }
    public void HideWanderInfo() { m_ShowWandererInfo = false; }

    /* Methods. */

    @Override
    public void Start()
    {
        m_RigidBody = m_GameObject.GetComponent(RigidBody.class);
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
        // m_RigidBody.SetVelocity(ZVector.sub(wanderedPos, transform().GetPosition()).normalize().mult(m_MovementSpeed));
        // Move(ZVector.sub(wanderedPos, transform().GetPosition()).normalize());
        m_RigidBody.ApplyForce(ZVector.sub(wanderedPos, transform().GetPosition()).normalize().mult(m_RigidBody.GetVelocity().mag()+1));
    }

    /*
     * Will move the animal in a direction specified by 'direction'.
     * The speed will in which the animal will move is specified by
     * 'm_MovementSpeed'.
    */
    protected void Move(ZVector direction)
    {
        m_RigidBody.ApplyForce(direction.copy().normalize().mult(5));
    }
}
