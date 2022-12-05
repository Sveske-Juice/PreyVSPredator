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
    protected float m_MovementSpeed = 35f;
    protected RigidBody m_RigidBody;

    /* Getters/Setters. */
    public float GetMovementSpeed() { return m_MovementSpeed; }

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
        
    }

    /*
     * Will move the animal in a direction specified by 'direction'.
     * The speed will in which the animal will move is specified by
     * 'm_MovementSpeed'.
    */
    protected void Move(ZVector direction)
    {
        m_RigidBody.ApplyForce(direction.copy().normalize().mult(m_MovementSpeed));
    }
}
