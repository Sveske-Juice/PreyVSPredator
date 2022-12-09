public class BushSpawnerObject extends GameObject
{
    public BushSpawnerObject()
    {
        super("Bush Spawner Object");
    }

    @Override
    public void CreateComponents()
    {
        AddComponent(new BushSpawner());
    }
}

public class BushSpawner extends Component
{
    private GameScene m_GameScene;

    @Override
    public void Start()
    {
        m_GameScene = (GameScene) m_GameObject.GetBelongingToScene();
        
        ZVector dimensions = m_GameScene.GetDimensions();

        // Populate list with bushes
        for (int i = 0; i < m_GameScene.GetGameSettings().GetBushCount(); i++)
        {
            ZVector randPos = new ZVector(random(-dimensions.x, dimensions.x), random(-dimensions.y, dimensions.y));
            GameObject bush = m_GameObject.GetBelongingToScene().AddGameObject(new BushObject());
            bush.GetTransform().SetPosition(randPos);
        }
    }
}

public class BushObject extends GameObject
{
    public BushObject()
    {
        super("Bush Object");
    }

    @Override
    public void CreateComponents()
    {
        AddComponent(new Polygon(loadShape("bush.svg")));
    }
}