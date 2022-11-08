public class GameObject
{
    /* Members. */
    protected String m_Name = "New GameObject";
    protected boolean m_ObjectStarted = false;
    
    protected ArrayList<Component> m_Components = new ArrayList<Component>();
    protected Transform m_Transform;
    
    // TODO support for parent and children
    public GameObject() {}

    public GameObject(String name)
    {
        m_Name = name;
    }

    /* Getters/Setters. */
    public String GetName() { return m_Name; }
    public Transform GetTransform() { return m_Transform; }

    /* Methods. */
    public void CreateComponents()
    {
        m_Transform = new Transform();
        AddComponent(m_Transform);
    }

    public void AddComponent(Component component)
    {
        if (component == null)
            return;
        
        print("Adding component: " + component.GetName() + " on object: " + m_Name + "\n");
        m_Components.add(component);
        
        // Link the component to this GameObject, 
        // so it can reference it later.
        component.SetGameObject(this);

        if (m_ObjectStarted)
            component.Start();
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
        m_ObjectStarted = true;        
        int size = m_Components.size();
        for (int i = 0; i < size; i++)
        {
            print("Starting component: " + m_Components.get(i).GetName() + " on object: " + m_Name + "\n");
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
