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
        //AddComponent(new PreyMover(5f));
    }
}

public class PreyMover extends AnimalMover
{
    private MoveController m_MoveController;
    private RigidBody m_RB;

    public PreyMover()
    {
        m_Name = "Prey Mover";
    }

    public PreyMover(float moveSpeed)
    {
        m_MovementSpeed = moveSpeed;
        m_Name = "Prey Mover";
    }

    @Override
    public void Start()
    {
        m_MoveController = m_GameObject.GetComponent(MoveController.class);
        m_RB = m_GameObject.GetComponent(RigidBody.class);
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
        

        //m_MoveController.SetVelocity(m_Movement.mult(m_MovementSpeed));
        //m_MoveController.Move();
        PVector force = m_Movement.mult(5);
        m_RB.ApplyForce(force);

        // radius resize
        CircleCollider collider = GetGameObject().GetComponent(CircleCollider.class);
        //println(InputManager.GetInstance().GetMap());
        if (collider != null)
        {
            if (InputManager.GetInstance().GetKey(38)) // up arrow
                collider.SetRadius(collider.GetRadius() + 0.5);
            else if (InputManager.GetInstance().GetKey(40)) // dwn arrow
                collider.SetRadius(collider.GetRadius() - 0.5);
        }

        BoxCollider box = GetGameObject().GetComponent(BoxCollider.class);
        if (box != null)
        {
            if (InputManager.GetInstance().GetKey(38))
                box.SetHeight(box.GetHeight() + 0.5);
            else if (InputManager.GetInstance().GetKey(40))
                box.SetHeight(box.GetHeight() - 0.5);
            else if (InputManager.GetInstance().GetKey(39))
                box.SetWidth(box.GetWidth() + 0.5);
            else if (InputManager.GetInstance().GetKey(37))
                box.SetWidth(box.GetWidth() - 0.5);
        }
    }
}