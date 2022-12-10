/*
 * Standard game settings.
*/
public class GameSettings
{
    /* Members. */
    protected int m_MaxPreyCount = 50;
    protected int m_CurrentPreyCount = 10;
    protected int m_MaxPredatorCount = 100;
    protected int m_CurrentPredatorCount = 3;
    protected int m_BushCount = 30;
    protected float m_PreySplitTime = 30f; // Amount of time for a prey split
    protected float m_AnimalMovementSpeed = 250f; // Default speed for animals
    protected float m_PredatorHuntSpeed = 300f; // Speed of predator when hunting prey (little bit faster than normal)

    /* Getters/Setters. */
    public int GetMaxPreyCount() { return m_MaxPreyCount; }
    public void SetCurrentPreyCount(int value) { m_CurrentPreyCount = value; }
    public int GetCurrentPreyCount() { return m_CurrentPreyCount; }
    public int GetMaxPredatorCount() { return m_MaxPredatorCount; }
    public void SetCurrentPredatorCount(int value) { m_CurrentPredatorCount = value; }
    public int GetCurrentPredatorCount() { return m_CurrentPredatorCount; }
    public int GetBushCount() { return m_BushCount; }
    public float GetPreySplitTime() { return m_PreySplitTime; }
    public float GetAnimalMovementSpeed() { return m_AnimalMovementSpeed; }
    public float GetPredatorHuntSpeed() { return m_PredatorHuntSpeed; }

    /*
     * Constructor for creating custom game settings.
    */
    public GameSettings(int maxPreyCount, int currentPreyCount, int maxPredatorCount, int currentPredatorCount, int bushCount, float preySplitTime, float animalMovementSpeed, float predatorHuntSpeed)
    {
        m_MaxPreyCount = maxPreyCount;
        m_CurrentPreyCount = currentPreyCount;
        m_MaxPredatorCount = maxPredatorCount;
        m_CurrentPredatorCount = currentPredatorCount;
        m_BushCount = bushCount;
        m_PreySplitTime = preySplitTime;
        m_AnimalMovementSpeed = animalMovementSpeed;
        m_PredatorHuntSpeed = predatorHuntSpeed;
    }

    /*
     * Default constructor.
    */
    public GameSettings() { }
}

/*
 * GAME SETTING PRESETS.
*/
public class SmallGameSettings extends GameSettings
{
    public SmallGameSettings()
    {
        // Set small game setting values
        m_MaxPreyCount = 75;
        m_CurrentPreyCount = 15;
        m_MaxPredatorCount = 50;
        m_CurrentPredatorCount = 3;
        m_BushCount = 35;
        m_PreySplitTime = 30f;
    }
}

public class MediumGameSettings extends GameSettings
{
    public MediumGameSettings()
    {
        // Set medium game setting values
        m_MaxPreyCount = 400;
        m_CurrentPreyCount = 30;
        m_MaxPredatorCount = 250;
        m_CurrentPredatorCount = 5;
        m_BushCount = 30;
        m_PreySplitTime = 30f;
    }
}

public class BigGameSettings extends GameSettings
{
    public BigGameSettings()
    {
        // Set big game setting values
        m_MaxPreyCount = 750;
        m_CurrentPreyCount = 75;
        m_MaxPredatorCount = 500;
        m_CurrentPredatorCount = 7;
        m_BushCount = 35;
        m_PreySplitTime = 20f;
    }
}

public class EpicGameSettings extends GameSettings
{
    public EpicGameSettings()
    {
        // Set epic game setting values
        m_MaxPreyCount = 2000;
        m_CurrentPreyCount = 300;
        m_MaxPredatorCount = 1500;
        m_CurrentPredatorCount = 15;
        m_BushCount = 45;
        m_PreySplitTime = 15f;
        m_AnimalMovementSpeed = 300f;
        m_PredatorHuntSpeed = 325f;
    }
}