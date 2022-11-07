public abstract class Animal extends GameObject 
{
    /* Members. */
    private float m_MoveSpeed;
    private PVector m_Velocity;
    private PVector m_Acceleration;
    
    public Animal(String name, float moveSpeed)
    {
        super(name);
        m_MoveSpeed = moveSpeed;
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();
    }
}
