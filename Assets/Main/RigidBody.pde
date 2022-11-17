public class RigidBody extends Component
{
    /* Members. */
    private PVector m_Gravity = new PVector(0f, 0f); // Defualt gravity acceleration
    private PVector m_Velocity = new PVector();
    private PVector m_Acceleration = new PVector();
    private PVector m_NetForce = new PVector();
    
    private float m_Mass = 1f; // Mass of entity

    private float m_DynamicFriction = 0.99f; // Dynamic friction coefficient

    private boolean m_TakesGravity = true; // If the rigidbody will simulate gravity
    private boolean m_IsSimulated = true; // If the rigidbody gets simulated. Still participates with collisions, but is unaffected.
    private boolean m_IsStatic = false;

    private Transform m_LastTrans; // Where the rigidbody was last step
    private Transform m_NextTrans; // Where the rigidbody will be next step if there is no interference

    /* Getters/Setters. */
    public PVector GetVelocity() { return m_Velocity; }
    public void SetVelocity(PVector velocity) { m_Velocity = velocity; }
    public float GetMass() { return m_Mass; }
    public void SetMass(float mass) { m_Mass = mass; }
    public boolean IsStatic() { return m_IsStatic; }

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

    public void ApplyForce(PVector force)
    {
        m_NetForce.add(force);
    }

    public void Move()
    {
        // Calculate an acceleration based on Newtons 2. law of motion
        m_Acceleration = m_NetForce.div(m_Mass);
        
        // Use Euler's method to get the position of the entity next frame
        m_Velocity.add(m_Acceleration);

        // Reset acceleration and the net force
        m_Acceleration.mult(0);
        m_NetForce.mult(0);

        transform().Position.add(PVector.mult(m_Velocity, Time.dt()));

    }

    public void ApplyGravity()
    {
        ApplyForce(PVector.mult(m_Gravity, m_Mass));
    }
}