public class SceneManager
{
    /* Members. */
    private ArrayList<Scene> m_Scenes = new ArrayList<Scene>();
    private Scene m_ActiveScene;
    
    /* Getters/Setters. */
    public ArrayList<Scene> GetScenes() { return m_Scenes; }
    public Scene GetActiveScene() { return m_ActiveScene; }
    
    /* Methods. */
    public void AddScene(Scene scene) { m_Scenes.add(scene); }
    
    /// Starts all the GameObjects in a scene
    /// specified by the argument "sceneName"
    public boolean LoadScene(String sceneName)
    {
        print("Loading scene: " + sceneName + "\n");
        for (int i = 0; i < m_Scenes.size(); i++)
        {
            // If scenenames match
            if (m_Scenes.get(i).GetSceneName() == sceneName)
            {
                // Exit objects on current scene
                if (m_ActiveScene != null)
                    m_ActiveScene.ExitObjects();

                // Load new scene by creating and starting all objects in that scene
                m_ActiveScene = m_Scenes.get(i);

                m_ActiveScene.CreateScene();

                // Create all the components on every GameObject
                CreateObjects(m_ActiveScene);

                // Start all the objects
                m_ActiveScene.StartObjects();
                return true;
            }
        }
        return false;
    }

    /// Create the components on all GameObjects in a scene
    private void CreateObjects(Scene scene)
    {
        if (scene == null)
            return;

        print("Creating all objects in scene: " + scene.GetSceneName() + "\n");
        ArrayList<GameObject> objects = scene.GetGameObjects();
        for (int i = 0; i < objects.size(); i++)
        {
            objects.get(i).CreateComponents();
        }
    }
    
    public void UpdateScene()
    {
         if (m_ActiveScene == null)
             return;
        
        m_ActiveScene.UpdateObjects();
    }
}
