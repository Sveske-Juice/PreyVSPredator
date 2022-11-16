public class MoveController extends Component
{
    /* Members. */
    private PVector m_Velocity = new PVector();
    private PVector m_Acceleration = new PVector();
    private float m_Weight = 1;

    /* Getters/Setters. */
    public PVector GetVelocity() { return m_Velocity; }
    public void SetVelocity(PVector velocity) { m_Velocity = velocity; }

    public MoveController()
    {
        m_Name = "Movement Controller";
    }

    public void Accelerate(PVector acceleration)
    {
        m_Velocity.add(acceleration);
        Move();
    }

    public void AddForce(PVector force)
    {
        m_Acceleration = force.div(m_Weight);
        m_Velocity.add(m_Acceleration);
        Move();
    }

    public void Move()
    {
        m_GameObject.m_Transform.Position.add(m_Velocity);
        m_Acceleration.mult(0);
        
    }
}