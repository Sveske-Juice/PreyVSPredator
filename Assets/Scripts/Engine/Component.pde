public abstract class Component
{
    /* Members. */
    protected String m_Name;
    
    /* Getters/Setters. */
    public String GetName() { return m_Name; }
    
    /* Methods. */
    public void Start() {}
    public void Update() {}
    public void Exit() {}    
}
