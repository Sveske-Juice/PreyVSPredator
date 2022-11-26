/// Base class for all scenes. Stores all the GameObjects 
/// and provides functionality to update each GameObject.
public abstract class Scene
{
    /* Members. */
    protected String m_SceneName = "New Scene";
    protected ArrayList<GameObject> m_GameObjects = new ArrayList<GameObject>();
    protected PVector m_Dimensions = new PVector(3000f, 3000f);
    private PVector m_MoveTranslation = new PVector();
    private float m_ScaleFactor = 1f;
    protected PhysicsSystem m_PhysicsSystem = new PhysicsSystem();
    private BitField m_MouseCollisionMask = new BitField();
    private int m_ComponentIdCounter = 0;
    
    /* Getters/Setters. */
    public String GetSceneName() { return m_SceneName; }
    public ArrayList<GameObject> GetGameObjects() { return m_GameObjects; }
    public void SetGameObjects(ArrayList<GameObject> objects) { m_GameObjects = objects; }
    public PhysicsSystem GetPhysicsSystem() { return m_PhysicsSystem; }
    public PVector GetDimensions() { return m_Dimensions; }
    public PVector GetMoveTranslation() { return m_MoveTranslation; }
    public void SetMoveTranslation(PVector translation) { m_MoveTranslation = translation; }
    public void SetScaleFactor(float factor) { m_ScaleFactor = factor; }
    public float GetScaleFactor() { return m_ScaleFactor; }
    public BitField GetMouseCollisionMask() { return m_MouseCollisionMask; }
    public int GetComponentIdCounter() { return m_ComponentIdCounter; }
    public void SetComponentIdCounter(int value) { m_ComponentIdCounter = value; }
    
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
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            m_GameObjects.get(i).StartObject();
        }
    }
    
    public void UpdateScene()
    {

        // Update all components on every GameObject in the scene
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            GameObject go = m_GameObjects.get(i); // Cache go
            
            pushMatrix();

            // If the GameObject is fixed then do not translate and scale
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

        // Tick physics system
        m_PhysicsSystem.Step(Time.dt());

        println("------------- new frame ------------");
    }
    
    public void ExitObjects()
    {
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            m_GameObjects.get(i).ExitObject();
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

        m_GameObjects.add(go);
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

        m_GameObjects.add(go);
        return go;
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

        // Camera handler
        GameObject camHandler = AddGameObject(new GameObject("Camera Handler"));
        camHandler.AddComponent(new CameraHandler());

        // Prey control display menu
        GameObject preyCtrlDisplay = AddGameObject(new PreyControlDisplayObject());
        

        
        GameObject prey1 = AddGameObject(new Prey("Prey1"));
        prey1.GetTransform().SetPosition(new PVector(200f, 100f));
        prey1.AddComponent(new AnimalInputController());
        
        RigidBody body = (RigidBody) prey1.AddComponent(new RigidBody());

        /*
        GameObject topborder = AddGameObject(new GameObject("Top Border"));
        RigidBody tbrb = (RigidBody) topborder.AddComponent(new RigidBody());
        topborder.AddComponent(new BoxCollider(width, 10f));
        topborder.Gettransform().GetPosition() = new PVector(0, 0);
        
        GameObject leftborder = AddGameObject(new GameObject("Left Border"));
        RigidBody lbrb = (RigidBody) leftborder.AddComponent(new RigidBody());
        leftborder.AddComponent(new BoxCollider(10f, height));
        leftborder.Gettransform().GetPosition() = new PVector(0, 0);

        
        GameObject rightborder = AddGameObject(new GameObject("Right Border"));
        RigidBody rbrb = (RigidBody) rightborder.AddComponent(new RigidBody());
        rightborder.AddComponent(new BoxCollider(10f, height));
        rightborder.Gettransform().GetPosition() = new PVector(width-10, 0);
        
        GameObject bottomborder = AddGameObject(new GameObject("Bottom Border"));
        RigidBody bbrb = (RigidBody) bottomborder.AddComponent(new RigidBody());
        bottomborder.AddComponent(new BoxCollider(width, 10f));
        bottomborder.Gettransform().GetPosition() = new PVector(0, height-30);
        */

        for (int i = 0; i < 0; i++)
        {
            PVector rand = new PVector(random(0, width), random(0, height-150));
            GameObject prey = AddGameObject(new Prey("Prey" + i));
            prey.AddComponent(new BoxCollider());
            prey.GetTransform().SetPosition(rand);
            RigidBody ibody = (RigidBody) prey.AddComponent(new RigidBody());
        }

        for (int i = 0; i < 1; i++)
        {
            PVector rand = new PVector(random(-m_Dimensions.x, m_Dimensions.x-150), random(-m_Dimensions.y, m_Dimensions.y-150));
            GameObject prey = AddGameObject(new Prey("Prey" + i));
            prey.GetTransform().SetPosition(rand); //PVector.sub(prey1.Gettransform().GetPosition(), new PVector(500, 500));
        }
        
    }
}