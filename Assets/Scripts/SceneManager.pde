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
                m_ActiveScene.StartObjects();
                return true;
            }
        }
        return false;
    }
}
