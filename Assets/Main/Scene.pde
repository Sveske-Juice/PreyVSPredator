/// Base class for all scenes. Stores all the GameObjects 
/// and provides functionality to update each GameObject.
public abstract class Scene
{
    /* Members. */
    protected String m_SceneName = "New Scene";
    protected ArrayList<GameObject> m_GameObjects = new ArrayList<GameObject>();
    protected CollissionSystem m_CollissionSystem = new CollissionSystem();
    
    /* Getters/Setters. */
    public String GetSceneName() { return m_SceneName; }
    public ArrayList<GameObject> GetGameObjects() { return m_GameObjects; }
    public void SetGameObjects(ArrayList<GameObject> objects) { m_GameObjects = objects; }
    public CollissionSystem GetCollissionSystem() { return m_CollissionSystem; }
    
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
        
        GameObject prey2 = AddGameObject(new Prey("Prey1"));
        prey2.GetTransform().Position = new PVector(width/2, height/2);
        prey2.AddComponent(new BoxCollider());
        prey2.AddComponent(new PreyMover(5f));

        
        for (int i = 0; i < 1; i++)
        {
            GameObject prey = AddGameObject(new Prey("Prey" + i));
            prey.GetTransform().Position = new PVector(random(0, width), random(0, height));
            prey.AddComponent(new BoxCollider());
        }

        for (int i = 0; i < 0; i++)
        {
            GameObject prey = AddGameObject(new Prey("Prey" + (i+4)));
            prey.GetTransform().Position = new PVector(random(0, width), random(0, height));
            prey.AddComponent(new CircleCollider());
        }
        /*
        GameObject pred1 = AddGameObject(new Predator("Pred1"));
        pred1.GetTransform().Position = new PVector(width/2, 25);
        prey1.AddComponent(new BoxCollider());

        
        GameObject prey3 = AddGameObject(new Prey("Prey3"));
        prey3.GetTransform().Position = new PVector(width/2, height/2);

        GameObject prey4 = AddGameObject(new Prey("Prey4"));
        prey4.GetTransform().Position = new PVector(width/2, height/2);
        
        GameObject prey5 = AddGameObject(new Prey("Prey5"));
        
        prey4.GetTransform().Position = new PVector(width/2, height/2);
        GameObject prey6 = AddGameObject(new Prey("Prey6"));

        prey4.GetTransform().Position = new PVector(width/2, height/2);
        GameObject prey7 = AddGameObject(new Prey("Prey7"));
        prey7.GetTransform().Position = new PVector(width/2, height/2);
        //AddGameObject(new Predator("Predator"));
        */
        
    }
}
