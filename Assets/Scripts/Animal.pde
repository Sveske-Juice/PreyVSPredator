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
    
    public void Start()
    {
        print("Starting Animal with name: " + m_Name + "\n");
    }
    
    public void Update()
    {
        print("Updating Animal with name: " + m_Name + "\n");
    }
}
