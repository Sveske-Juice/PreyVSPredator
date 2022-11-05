public class GameObject
{
    /* Members. */
    protected String m_Name;
    
    protected ArrayList<Component> m_Components = new ArrayList<Component>();
    
    // TODO support for parent and children
    public GameObject(String name)
    {
        m_Name = name;
    }

    /* Methods. */
    public void AddComponent(Component component)
    {
        if (component == null)
            return;
        
        m_Components.add(component);
        
        // Link the component to this GameObject, 
        // so it can reference it later.
        component.SetGameObject(this);
    }
    
    /// Gets a component of type T on this GameObject.
    /// Returns the component if it could be found or null if it couldn't.
    public <T extends Component> T GetComponent(Class<T> componentClassType)
    {
        for (int i = 0; i < m_Components.size(); i++)
        {
            Component component = m_Components.get(i);
            
            // Check if the type of component we're looking for is the same type "component"
            if (componentClassType.isAssignableFrom(component.getClass()))
            {
                 return componentClassType.cast(component);
            }
        }
        return null;
    }
    
     /// Removes a component of type T on this GameObject.
    /// Returns true if it was removed or false if it couldn't be.
    public <T extends Component> boolean RemoveComponent(Class<T> componentClassType)
    {
        for (int i = 0; i < m_Components.size(); i++)
        {
            Component component = m_Components.get(i);
            
            // Check if the type of component we're looking for is the same type "component"
            if (componentClassType.isAssignableFrom(component.getClass()))
            {
                 m_Components.remove(component);
                 return true;                 
            }
        }
        return false;
    }
    

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
