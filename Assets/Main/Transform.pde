public class Transform extends Component
{
  /* Members. */
  private PVector m_Position = new PVector();
  public PVector Rotation = new PVector();
  public PVector Scale = new PVector();

  private ArrayList<Transform> m_Children = new ArrayList<Transform>();
  private Transform m_Parent = this;

  /* Getters/Setters. */
  public void SetPosition(PVector newPos) { UpdatePositionRecursively(newPos); }
  public void AddToPosition(PVector amount) { UpdatePositionRecursively(m_Position.add(amount)); }
  public void SubFromPosition(PVector amount) { UpdatePositionRecursively(m_Position.sub(amount)); }
  public PVector GetPosition() { return m_Position; }
  public Transform GetParent() { return m_Parent; }
  public void SetParent(Transform parent) { m_Parent = parent; }
  public Transform GetChild(int idx) { return m_Children.get(idx); }
  public void AddChild(Transform child) { m_Children.add(child); child.SetParent(this); }
  public int GetChildCount() { return m_Children.size(); }

  public Transform()
  {
    m_Name = "Transform";
  }

  // Updates the position of this transform aswell as children's transforms
  private void UpdatePositionRecursively(PVector newPos)
  {
    if (newPos == null)
      return;

    // Set this transform position
    m_Position = newPos;

    // Update children's transforms
    for (int i = 0; i < m_Children.size(); i++)
    {
      // println("adding pos on obj: " + m_Children.get(i).GetGameObject().GetName() + " adder: " + newPos);
      m_Children.get(i).UpdatePositionRecursively(newPos);
    }
  }
}
