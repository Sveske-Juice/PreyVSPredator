public class RigidBody extends Component
{
    /* Members. */
    private ZVector m_Gravity = new ZVector(0f, 0f); // Defualt gravity acceleration
    private ZVector m_Velocity = new ZVector();
    private ZVector m_Acceleration = new ZVector();
    private ZVector m_NetForce = new ZVector();
    
    private float m_Mass = 25f; // Mass of entity

    private float m_DynamicFriction = 0.95f; // Dynamic friction coefficient
    private float m_MaxSpeed = 500;

    private boolean m_TakesGravity = true; // If the rigidbody will simulate gravity


    /* Getters/Setters. */
    public ZVector GetVelocity() { return m_Velocity; }
    public void SetVelocity(ZVector velocity) { m_Velocity = velocity; }
    public float GetMass() { return m_Mass; }
    public void SetMass(float mass) { m_Mass = mass; }
    public void SetMaxSpeed(float value) { m_MaxSpeed = value; }


    /* Constructors. */
    public RigidBody()
    {
        m_Name = "Rigid Body";
    }

    /* Methods. */

    @Override
    public void Start()
    {
        m_GameObject.GetBelongingToScene().GetPhysicsSystem().RegisterBody(this);
    }

    public void ApplyForce(ZVector force)
    {
        m_NetForce.add(force);
    }

    public void Move()
    {
        // Calculate an acceleration based on Newtons 2. law of motion
        m_Acceleration = m_NetForce.div(m_Mass);
        
        // Use Euler's method to get the position of the entity next frame
        m_Velocity.add(m_Acceleration);
        m_Velocity.limit(m_MaxSpeed);


        // Reset acceleration and the net force
        m_Acceleration.mult(0);
        m_NetForce.mult(0);

        transform().AddToPosition(ZVector.mult(m_Velocity, Time.dt()));

        // Simulate the dynamic friction of the body
        m_Velocity.mult(m_DynamicFriction);
    }

    public void ApplyGravity()
    {
        ApplyForce(ZVector.mult(m_Gravity, m_Mass));
    }

    public float CalcEKin()
    {
        return 0.5f * m_Mass * pow(m_Velocity.mag(), 2);
    }
}