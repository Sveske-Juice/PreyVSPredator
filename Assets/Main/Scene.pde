/// Base class for all scenes. Stores all the GameObjects 
/// and provides functionality to update each GameObject.
public abstract class Scene
{
    /* Members. */
    protected String m_SceneName = "New Scene";
    protected ArrayList<GameObject> m_GameObjects = new ArrayList<GameObject>();
    protected CollissionSystem m_CollissionSystem = new CollissionSystem();

    protected PhysicsSystem m_PhysicsSystem = new PhysicsSystem();
    
    /* Getters/Setters. */
    public String GetSceneName() { return m_SceneName; }
    public ArrayList<GameObject> GetGameObjects() { return m_GameObjects; }
    public void SetGameObjects(ArrayList<GameObject> objects) { m_GameObjects = objects; }
    public CollissionSystem GetCollissionSystem() { return m_CollissionSystem; }
    public PhysicsSystem GetPhysicsSystem() { return m_PhysicsSystem; }
    
    public Scene(String sceneName)
    {
        m_SceneName = sceneName;
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
    
    public void UpdateObjects()
    {
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            m_GameObjects.get(i).UpdateObject();
        }

        m_PhysicsSystem.Step(Time.dt());
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

        m_GameObjects.add(go);
        return go;
    }
}

public class GameScene extends Scene
{
    private PVector m_Dimensions = new PVector(500f, 500f);
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
        // Camera handler
        GameObject camHandler = AddGameObject(new GameObject("Camera Handler"));
        camHandler.AddComponent(new CameraHandler());
        
        GameObject prey1 = AddGameObject(new Prey("Prey1"));
        prey1.GetTransform().Position = new PVector(200f, 100f);
        prey1.AddComponent(new PreyMover(5f));
        
        CircleCollider collider = (CircleCollider) prey1.AddComponent(new CircleCollider());
        collider.SetTrigger(false);
        RigidBody body = (RigidBody) prey1.AddComponent(new RigidBody());
        body.SetMass(20f);

        /*
        GameObject topborder = AddGameObject(new GameObject("Top Border"));
        RigidBody tbrb = (RigidBody) topborder.AddComponent(new RigidBody());
        topborder.AddComponent(new BoxCollider(width, 10f));
        topborder.GetTransform().Position = new PVector(0, 0);
        
        GameObject leftborder = AddGameObject(new GameObject("Left Border"));
        RigidBody lbrb = (RigidBody) leftborder.AddComponent(new RigidBody());
        leftborder.AddComponent(new BoxCollider(10f, height));
        leftborder.GetTransform().Position = new PVector(0, 0);

        
        GameObject rightborder = AddGameObject(new GameObject("Right Border"));
        RigidBody rbrb = (RigidBody) rightborder.AddComponent(new RigidBody());
        rightborder.AddComponent(new BoxCollider(10f, height));
        rightborder.GetTransform().Position = new PVector(width-10, 0);
        
        GameObject bottomborder = AddGameObject(new GameObject("Bottom Border"));
        RigidBody bbrb = (RigidBody) bottomborder.AddComponent(new RigidBody());
        bottomborder.AddComponent(new BoxCollider(width, 10f));
        bottomborder.GetTransform().Position = new PVector(0, height-30);
        */

        for (int i = 0; i < 0; i++)
        {
            PVector rand = new PVector(random(0, width), random(0, height-150));
            GameObject prey = AddGameObject(new Prey("Prey" + i));
            prey.AddComponent(new BoxCollider());
            prey.GetTransform().Position = rand;
            RigidBody ibody = (RigidBody) prey.AddComponent(new RigidBody());
        }

        for (int i = 0; i < 1; i++)
        {
            PVector rand = new PVector(random(-m_Dimensions.x, m_Dimensions.x-150), random(-m_Dimensions.y, m_Dimensions.y-150));
            GameObject prey = AddGameObject(new Prey("Prey" + i));
            CircleCollider col = (CircleCollider) prey.AddComponent(new CircleCollider());
            col.SetTrigger(true);
            prey.GetTransform().Position = rand; //PVector.sub(prey1.GetTransform().Position, new PVector(500, 500));
            RigidBody ibody = (RigidBody) prey.AddComponent(new RigidBody());
        }
        
    }
}
