/*
 * Base class for all scenes. Stores all the GameObjects 
 * and provides functionality to update each GameObject.
*/
public abstract class Scene
{
    /* Members. */
    protected String m_SceneName = "New Scene";
    protected ArrayList<GameObject> m_GameObjects = new ArrayList<GameObject>();
    protected ArrayList<GameObject> m_UIObjects = new ArrayList<GameObject>();
    protected ZVector m_Dimensions = new ZVector(3000f, 3000f);
    private ZVector m_MoveTranslation = new ZVector();
    private float m_ScaleFactor = 1f;
    protected PhysicsSystem m_PhysicsSystem = new PhysicsSystem();
    private BitField m_MouseCollisionMask = new BitField();
    private int m_ComponentIdCounter = 0;
    private int m_ObjectIdCounter = 0;
    private boolean m_SceneStarted = false;
    private int m_MaxPreyCount = 0;
    private int m_CurrentPreyCount = 1;
    private int m_MaxPredatorCount = 400;
    private int m_CurrentPredatorCount = 0;
    private float m_ObjectFM = 0; // Object Update Frame Time
    private float m_LateObjectFM = 0; // Late Object Update Frame Time
    private float m_UIFM = 0; // UI Element Update Frame Time
    private float m_LateUIFM = 0; // Late UI Element Update Frame Time
    private float m_PhysicsFM = 0; // Physics system update frame time
    
    /* Getters/Setters. */
    public String GetSceneName() { return m_SceneName; }
    public ArrayList<GameObject> GetGameObjects() { return m_GameObjects; }
    public void SetGameObjects(ArrayList<GameObject> objects) { m_GameObjects = objects; }
    public PhysicsSystem GetPhysicsSystem() { return m_PhysicsSystem; }
    public ZVector GetDimensions() { return m_Dimensions; }
    public ZVector GetMoveTranslation() { return m_MoveTranslation; }
    public void SetMoveTranslation(ZVector translation) { m_MoveTranslation = translation; }
    public void SetScaleFactor(float factor) { m_ScaleFactor = factor; }
    public float GetScaleFactor() { return m_ScaleFactor; }
    public BitField GetMouseCollisionMask() { return m_MouseCollisionMask; }
    public int GetComponentIdCounter() { return m_ComponentIdCounter; }
    public void SetComponentIdCounter(int value) { m_ComponentIdCounter = value; }
    public int GetMaxPreyCount() { return m_MaxPreyCount; }
    public void SetCurrentPreyCount(int value) { m_CurrentPreyCount = value; }
    public int GetCurrentPreyCount() { return m_CurrentPreyCount; }
    public int GetMaxPredatorCount() { return m_MaxPredatorCount; }
    public void SetCurrentPredatorCount(int value) { m_CurrentPredatorCount = value; }
    public int GetCurrentPredatorCount() { return m_CurrentPredatorCount; }
    public float GetObjectFM() { return m_ObjectFM / 1000; }
    public float GetLateObjectFM() { return m_LateObjectFM / 1000; }
    public float GetUIFM() { return m_UIFM / 1000; }
    public float GetLateUIFM() { return m_LateUIFM / 1000; }
    public float GetPhysicsFM() { return m_PhysicsFM / 1000; }
    public float GetFPS() { return 1 / Time.dt(); }
    
    public Scene(String sceneName)
    {
        m_SceneName = sceneName;

        // Setup mouse collision mask
        m_MouseCollisionMask.SetBit(CollisionLayer.ANIMAL_MAIN_COLLIDER.ordinal());
        m_MouseCollisionMask.SetBit(CollisionLayer.UI_ELEMENT.ordinal());
    }
    
    /* Methods. */
    public abstract void CreateScene();
    
    // TODO use delegate for 3 methods below
    public void StartObjects()
    {
        m_PhysicsSystem.SetBelongingToScene(this); // Give collisionworld a reference to this scene

        // Start GameObjects
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            m_GameObjects.get(i).StartObject();
        }

        // Start UI Objects
        for (int i = 0; i < m_UIObjects.size(); i++)
        {
            m_UIObjects.get(i).StartObject();
        }

        m_SceneStarted = true;
    }
    
    public void UpdateScene()
    {
        // Update all components on every GameObject in the scene
        long goT = millis();
        
        // println("objects: " + m_GameObjects.size());

        /* Tick Update() on every normal GameObject in scene. */
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            // long objiT = millis();
            GameObject go = m_GameObjects.get(i); // Cache go
            
            pushMatrix();

            // If the GameObject is fixed then do not translate and scale (Is fixed on UIElement)
            if (!go.IsFixed())
            {
                // Translate and scale
                translate(width / 2f, height / 2f);
                scale(m_ScaleFactor);
                translate(-m_MoveTranslation.x - width / 2f, -m_MoveTranslation.y - height / 2f);    
            }
            
            go.UpdateObject();
            popMatrix();
            // println("Object " + go.GetName() + " frame time: " + (millis() - objiT));
        }
        m_ObjectFM = (millis() - goT);
        // println("Object update frame time: " + m_ObjectFM);

        long uiT = millis();
        /*  Tick Update() on every UI GameObject (UIElement),
            so they are on top of normal GameObjects. */
        for (int i = 0; i < m_UIObjects.size(); i++)
        {
            GameObject go = m_UIObjects.get(i); // Cache go
            pushMatrix();
            // println("Updating: " + go.GetName());

            // If the UI Element is fixed then do not translate and scale (Is fixed on UIElement)
            if (!go.IsFixed())
            {
                // Translate and scale
                translate(width / 2f, height / 2f);
                scale(m_ScaleFactor);
                translate(-m_MoveTranslation.x - width / 2f, -m_MoveTranslation.y - height / 2f);    
            }
            
            go.UpdateObject();
            popMatrix();
        }
        m_UIFM = (millis() - uiT);
        // println("UI update frame time: " + m_UIFM);

        /* Tick physics system. */
        long phyT = millis();

        pushMatrix();
        
        // Scale and translate for physics system
        translate(width / 2f, height / 2f);
        scale(m_ScaleFactor);
        translate(-m_MoveTranslation.x - width / 2f, -m_MoveTranslation.y - height / 2f);  
        
        m_PhysicsSystem.Step(Time.dt());
        
        popMatrix();

        m_PhysicsFM = (millis() - phyT);
        // println("Physics update frame time: " + m_PhysicsFM);

        /*  Tick LateUpdate() on every normal GameObject. */
        long lateGoT = millis();
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            GameObject go = m_GameObjects.get(i);
            
            pushMatrix();

            if (!go.IsFixed())
            {
                // Translate and scale
                translate(width / 2f, height / 2f);
                scale(m_ScaleFactor);
                translate(-m_MoveTranslation.x - width / 2f, -m_MoveTranslation.y - height / 2f);
            }
            
            go.LateUpdateObject();
            popMatrix();
        }
        m_LateObjectFM = (millis() - lateGoT);
        // println("Object LATE update frame time: " + m_LateObjectFM);

        /*  Tick LateUpdate() on every UI Object (UIElement), so they get
            ticked after normal objects. */
        long lateUiT = millis();
        for (int i = 0; i < m_UIObjects.size(); i++)
        {
            GameObject go = m_UIObjects.get(i);
            
            pushMatrix();

            if (!go.IsFixed())
            {
                // If the UI Element is fixed then do not translate and scale (Is fixed on UIElement)
                translate(width / 2f, height / 2f);
                scale(m_ScaleFactor);
                translate(-m_MoveTranslation.x - width / 2f, -m_MoveTranslation.y - height / 2f);   
            }
            
            go.LateUpdateObject();
            popMatrix();
        }
        m_LateUIFM = (millis() - lateUiT);
        // println("UI LATE update frame time: " + m_LateUIFM);

        // println("------------- new frame ------------");
    }
    
    public void ExitObjects()
    {
        // Exit GameObject
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            m_GameObjects.get(i).ExitObject();
        }

        // Exit UI Elements
        for (int i = 0; i < m_UIObjects.size(); i++)
        {
            m_UIObjects.get(i).ExitObject();
        }
    }
    
    public GameObject AddGameObject(GameObject go)
    {
        if (go == null)
            return null;
        
        // Set a reference to this scene so the Game Object can access the scene
        go.SetBelongingToScene(this);

        // Make sure every GameObject have a transform
        go.CreateTransform();

        // Set id
        go.SetId(m_ObjectIdCounter++);

        if (go instanceof UIElement)
            m_UIObjects.add(go);
        else
            m_GameObjects.add(go);

        if (m_SceneStarted)
        {
            go.CreateComponents();
            go.StartObject();
        }
        
        return go;
    }

    public GameObject AddGameObject(GameObject go, ZVector position)
    {
        if (go == null)
            return null;
        
        // Set a reference to this scene so the Game Object can access the scene
        go.SetBelongingToScene(this);

        // Make sure every GameObject have a transform
        go.CreateTransform(position);

        // Set id
        go.SetId(m_ObjectIdCounter++);

        if (go instanceof UIElement)
            m_UIObjects.add(go);
        else
            m_GameObjects.add(go);

        if (m_SceneStarted)
        {
            go.CreateComponents();
            go.StartObject();
        }
        
        return go;
    }

    public GameObject AddGameObject(GameObject go, Transform parent)
    {
        if (go == null)
            return null;
        

        // Set a reference to this scene so the Game Object can access the scene
        go.SetBelongingToScene(this);

        // Make sure every GameObject have a transform
        go.CreateTransform();

        // Set parent - child relationship
        parent.AddChild(go.GetTransform());

        // Set new child's position to parent's
        go.GetTransform().SetPosition(parent.GetPosition());

        // Set id
        go.SetId(m_ObjectIdCounter++);

        RegisterGameObjectInScene(go);

        if (m_SceneStarted)
        {
            go.CreateComponents();
        }

        // Give the GameObject a chance to create children (update their positions)
        ArrayList<GameObject> children = go.CreateChildren();
        if (children != null)
        {
            for (int i = 0; i < children.size(); i++)
            {
                println("adding child: " + children.get(i).GetName());
                AddGameObject(children.get(i), go.GetTransform());
            }
        }

        if (m_SceneStarted)
        {
            go.StartObject();
        }

        
        return go;
    }

    /*
     * Will add the GameObject to it's respictive list in the scene.
    */
    private void RegisterGameObjectInScene(GameObject go)
    {
        if (go instanceof UIElement)
            m_UIObjects.add(go);
        else
            m_GameObjects.add(go);
    }

    public void DestroyGameObject(int id)
    {
        // Check in GameObjects
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            if (m_GameObjects.get(i).GetId() == id)
            {
                m_GameObjects.set(i, null);
                m_GameObjects.remove(i);
                break;
            }
        }

        // Check in UI Objects
        for (int i = 0; i < m_UIObjects.size(); i++)
        {
            if (m_UIObjects.get(i).GetId() == id)
            {
                m_UIObjects.set(i, null);
                m_UIObjects.remove(i);
                break;
            }
        }
    }

    public GameObject FindGameObject(String name)
    {
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            if (m_GameObjects.get(i).GetName() == name)
            {
                return m_GameObjects.get(i);
            }
        }

        return null;
    }
}

public class GameScene extends Scene
{
    public GameScene(String sceneName)
    {
        super(sceneName);
    }

    public GameScene()
    {
        super("Game Scene");
    }
    
    public void CreateScene()
    {
        // Mouse click event handler
        AddGameObject(new MouseEventInitiatorObject());

        // Collider quad tree debugger
        AddGameObject(new DebugColliderTreeObject());

        // Camera handler
        // TODO use preab
        GameObject camHandler = AddGameObject(new GameObject("Camera Handler"));
        camHandler.AddComponent(new CameraHandler());

        // Prey control display menu
        GameObject preyCtrlDisplay = AddGameObject(new PreyControlDisplayObject());

        // Predator control display menu
        GameObject predatorCtrlDisplay = AddGameObject(new PredatorControlDisplayObject());

        // Animal event initiator
        GameObject animalEventInitiator = AddGameObject(new AnimalEventInitiatorObject());

        // Debug displayer
        GameObject debugDisplay = AddGameObject(new DebugDisplayObject());
        

        
        GameObject prey1 = AddGameObject(new Prey("Prey1"));
        prey1.GetTransform().SetPosition(new ZVector(200f, 100f));

        GameObject predator = AddGameObject(new Predator("Predator"));
        predator.GetTransform().SetPosition(new ZVector(width, 100f));
        // prey1.AddComponent(new AnimalInputController());
        
        // RigidBody body = (RigidBody) prey1.AddComponent(new RigidBody());

        /*
        GameObject topborder = AddGameObject(new GameObject("Top Border"));
        RigidBody tbrb = (RigidBody) topborder.AddComponent(new RigidBody());
        topborder.AddComponent(new BoxCollider(width, 10f));
        topborder.Gettransform().GetPosition() = new ZVector(0, 0);
        
        GameObject leftborder = AddGameObject(new GameObject("Left Border"));
        RigidBody lbrb = (RigidBody) leftborder.AddComponent(new RigidBody());
        leftborder.AddComponent(new BoxCollider(10f, height));
        leftborder.Gettransform().GetPosition() = new ZVector(0, 0);

        
        GameObject rightborder = AddGameObject(new GameObject("Right Border"));
        RigidBody rbrb = (RigidBody) rightborder.AddComponent(new RigidBody());
        rightborder.AddComponent(new BoxCollider(10f, height));
        rightborder.Gettransform().GetPosition() = new ZVector(width-10, 0);
        
        GameObject bottomborder = AddGameObject(new GameObject("Bottom Border"));
        RigidBody bbrb = (RigidBody) bottomborder.AddComponent(new RigidBody());
        bottomborder.AddComponent(new BoxCollider(width, 10f));
        bottomborder.Gettransform().GetPosition() = new ZVector(0, height-30);
        */

        for (int i = 0; i < 0; i++)
        {
            ZVector rand = new ZVector(random(-m_Dimensions.x, m_Dimensions.x), random(-m_Dimensions.y, m_Dimensions.y));
            GameObject prey = AddGameObject(new Prey("Prey1"));
            prey.GetTransform().SetPosition(rand);
        }

        for (int i = 0; i < 0; i++)
        {
            ZVector rand = new ZVector(random(-m_Dimensions.x, m_Dimensions.x-150), random(-m_Dimensions.y, m_Dimensions.y-150));
            GameObject prey = AddGameObject(new Prey("Prey" + i));
            prey.GetTransform().SetPosition(rand); //ZVector.sub(prey1.Gettransform().GetPosition(), new ZVector(500, 500));
        }
        
    }
}