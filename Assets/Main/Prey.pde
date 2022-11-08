public class Prey extends Animal
{
    public Prey(String name)
    {
        super(name);
    }
    
    @Override
    public void CreateComponents()
    {
        super.CreateComponents();
        AddComponent(new PreyMover(5f));
    }
}

public class PreyMover extends AnimalMover
{
    private MoveController m_MoveController;

    public PreyMover()
    {
        m_Name = "Prey Mover";
    }

    public PreyMover(float moveSpeed)
    {
        m_MovementSpeed = moveSpeed;
    }

    @Override
    public void Start()
    {
        m_MoveController = m_GameObject.GetComponent(MoveController.class);
    }

    @Override
    public void Update()
    {
        PVector m_Movement = new PVector();
        if (InputManager.GetInstance().GetKey('w'))
            m_Movement.y = -1;
        else if (InputManager.GetInstance().GetKey('s'))
            m_Movement.y = 1;
        
        if (InputManager.GetInstance().GetKey('a'))
            m_Movement.x = -1;
        else if (InputManager.GetInstance().GetKey('d'))
            m_Movement.x = 1;
        
        m_MoveController.SetVelocity(m_Movement.mult(m_MovementSpeed));
        m_MoveController.Move();
        print(m_GameObject.GetTransform().Position + "\n");
    }


}
