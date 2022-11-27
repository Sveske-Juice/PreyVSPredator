public class GameObject
{
    /* Members. */
    protected String m_Name = "New GameObject";
    protected int m_ObjectId;
    protected boolean m_ObjectStarted = false;
    protected Scene m_BelongingToScene = null;
    protected String m_Tag = "Default";
    protected boolean m_FixedPosition = false;

    protected ArrayList<Component> m_Components = new ArrayList<Component>();
    protected Transform m_Transform;

    /* Getters/Setters. */
    public Scene GetBelongingToScene() { return m_BelongingToScene; }
    public void SetBelongingToScene(Scene scene) { m_BelongingToScene = scene; }
    public ArrayList<Component> GetComponents() { return m_Components; }
    public String GetName() { return m_Name; }
    public Transform GetTransform() { return m_Transform; }
    public void SetTag(String tag) { m_Tag = tag; }
    public String GetTag() { return m_Tag; }
    public boolean IsFixed() { return m_FixedPosition; }
    public void SetFixed(boolean value) { m_FixedPosition = value; }
    public void SetId(int value) { m_ObjectId = value; }
    public int GetId() { return m_ObjectId; }

    public GameObject() { }

    public GameObject(String name)
    {
        m_Name = name;
    }

    /* Methods. */
    public void CreateTransform()
    {
        // Always add a transform to a Game Object
        m_Transform = new Transform();
        AddComponent(m_Transform);
    }

    public void CreateComponents() { }

    public Component AddComponent(Component component)
    {
        if (component == null)
            return null;
        
        print("Adding component: " + component.GetName() + " on object: " + m_Name + "\n");
        m_Components.add(component);
        
        // Link the component to this GameObject, 
        // so it can reference it later.
        component.SetGameObject(this);

        // Set unique component id
        component.SetId(m_BelongingToScene.GetComponentIdCounter());

        // Increment global component id counter
        m_BelongingToScene.SetComponentIdCounter(m_BelongingToScene.GetComponentIdCounter() + 1);
        

        if (m_ObjectStarted)
            component.Start();
        
        return component;
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

    public void Destroy()
    {
        // Loop through all children and exit and remove the components
        for (int i = 0; i < m_Transform.GetChildCount(); i++)
        {
            m_Transform.GetChild(i).GetGameObject().Destroy();
        }

        // Exit all components on this GameObject
        ExitObject();

        // Set all components to null so GC can collect mem
        for (int i = 0; i < m_Components.size(); i++)
        {
            m_Components.get(i);
        }
        
        m_Components.clear();

        m_BelongingToScene.DestroyGameObject(m_ObjectId);
    }
    
    public void StartObject()
    {
        m_ObjectStarted = true;
        for (int i = 0; i < m_Components.size(); i++)
        {
            print("Starting component: " + m_Components.get(i).GetName() + " on object: " + m_Name + "\n");
            Component component = m_Components.get(i);

            if (component.IsEnabled())
                component.Start();
        }
        
    }
    
    public void UpdateObject()
    {
        for (int i = 0; i < m_Components.size(); i++)
        {
            Component component = m_Components.get(i);

            if (component.IsEnabled())
                component.Update();
        }
    }
    
    public void ExitObject()
    {
        for (int i = 0; i < m_Components.size(); i++)
        {
            print("Exiting component: " + m_Components.get(i).GetName() + " on object: " + m_Name + "\n");
            m_Components.get(i).Exit();
        }
    }
}
