public class AnimalInputController extends Component
{
    private AnimalMover m_AnimalMover;
    private RigidBody m_RigidBody;

    public AnimalInputController()
    {
        m_Name = "Animal Input Controller";
    }

    @Override
    public void Start()
    {
        m_AnimalMover = m_GameObject.GetComponent(AnimalMover.class);
        m_RigidBody = m_GameObject.GetComponent(RigidBody.class);
    }

    @Override
    public void Update()
    {
        // println("Components: " + m_GameObject.GetComponents());
        PVector m_Movement = new PVector();
        
        if (InputManager.GetInstance().GetKey('w'))
            m_Movement.y = -1;
        else if (InputManager.GetInstance().GetKey('s'))
            m_Movement.y = 1;
        
        if (InputManager.GetInstance().GetKey('a'))
            m_Movement.x = -1;
        else if (InputManager.GetInstance().GetKey('d'))
            m_Movement.x = 1;
        

        if (InputManager.GetInstance().GetKey('g'))
        {
            m_Movement = new PVector();
            m_RigidBody.SetVelocity(new PVector());
        }
        PVector force = m_Movement.mult(m_AnimalMover.GetMovementSpeed());
        m_RigidBody.ApplyForce(force);
        // println(force);

        // Resize colliders (debug)
        CircleCollider collider = (CircleCollider) m_GameObject.GetComponent(CircleCollider.class);
        
        if (collider != null)
        {
            if (InputManager.GetInstance().GetKey(38)) // up arrow
                collider.SetRadius(collider.GetRadius() + 0.5);
            else if (InputManager.GetInstance().GetKey(40)) // dwn arrow
                collider.SetRadius(collider.GetRadius() - 0.5);
        }

        BoxCollider box = m_GameObject.GetComponent(BoxCollider.class);
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