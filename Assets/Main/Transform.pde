public class Transform extends Component
{
  public PVector Position;
  public PVector Rotation;
  public PVector Scale;

  public Transform()
  {
    m_Name = "Transform";
  }

  @Override
  public void Start()
  {
    //print("Transform starting on object: " + m_GameObject.GetName() + "\n");
    m_GameObject.AddComponent(new InputController());
  }

  public void Update()
  {

  }
}
