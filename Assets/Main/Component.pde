public abstract class Component
{
    /* Members. */
    protected String m_Name = "New Component";
    protected GameObject m_GameObject;
    
    /* Getters/Setters. */
    public String GetName() { return m_Name; }
    public void SetGameObject(GameObject go) { m_GameObject = go; }
    public GameObject GetGameObject() { return m_GameObject; }
    public Transform transform() { return GetGameObject().GetTransform(); } // Get Transform shortcut
    
    /* Methods. */
    public void Start() {}
    public void Update() {}
    public void Exit() {}
}