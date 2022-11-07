public abstract class Component
{
    /* Members. */
    protected String m_Name;
    protected GameObject m_GameObject;
    
    /* Getters/Setters. */
    public String GetName() { return m_Name; }
    public void SetGameObject(GameObject go) { m_GameObject = go; }
    
    /* Methods. */
    public void Start() {}
    public void Update() {}
    public void Exit() {}
}
