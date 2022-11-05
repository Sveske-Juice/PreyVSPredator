/// Base class for all scenes. Stores all the GameObjects 
/// and provides functionality to update each GameObject.
public abstract class Scene
{
    /* Members. */
    protected String m_SceneName;
    protected ArrayList<GameObject> m_GameObjects = new ArrayList<GameObject>();
    
    /* Getters/Setters. */
    public String GetSceneName() { return m_SceneName; }
    public ArrayList<GameObject> GetGameObjects() { return m_GameObjects; }
    public void SetGameObjects(ArrayList<GameObject> objects) { m_GameObjects = objects; }
    
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
            m_GameObjects.get(i).Start();
        }
    }
    
    public void UpdateObjects()
    {
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            m_GameObjects.get(i).Update();
        }
    }
    
    public void ExitObjects()
    {
        for (int i = 0; i < m_GameObjects.size(); i++)
        {
            m_GameObjects.get(i).Exit();
        }
    }
}

public class GameScene extends Scene
{
    public GameScene(String sceneName)
    {
        super(sceneName);
    }
    
    public void CreateScene()
    {
        m_GameObjects.add(new Prey("Prey", 5f));
        m_GameObjects.add(new Predator("Predator", 5f));
    }
}
