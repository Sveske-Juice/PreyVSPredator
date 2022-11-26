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

  /*  
      Sets the transforms position relative to its parent(s).
      Will not set the absolute position but rather an offset from
      it's parent.
  */
  public void SetLocalPosition(PVector pos)
  {
    // If it's the root transform
    if (m_Parent == this)
    {
      m_Position = pos;
      return;
    }

    // Sum up all the parent positions
    m_Position = new PVector();
    Transform currentParent = m_Parent;
    while (currentParent.GetId() != currentParent.GetParent().GetId())
    {
      m_Position.add(currentParent.GetPosition());
      currentParent = currentParent.GetParent();
    }
    m_Position.add(pos);
  }
  
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
