public class GameObject
{
    /* Members. */
    protected String m_Name;
    protected GameObject m_Parent;
    protected GameObject[] m_Children;
    
    protected ArrayList<Component> m_Components = new ArrayList<Component>();
    
    // TODO support for parent and children
    public GameObject(String name)
    {
        m_Name = name;
    }

    /* Methods. */
    public void AddComponent(Component component)
    {
        m_Components.add(component);
    }
    
    public 
    
    // TODO use delegate for method
    public void StartObject()
    {
        for (int i = 0; i < m_Components.size(); i++)
        {
            m_Components.get(i).Start();
        }
    }
    
    public void UpdateObject()
    {
        for (int i = 0; i < m_Components.size(); i++)
        {
            m_Components.get(i).Update();
        }
    }
    
    public void ExitObject()
    {
        for (int i = 0; i < m_Components.size(); i++)
        {
            m_Components.get(i).Exit();
        }
    }
}
