/*
 * Standard game settings.
*/
public class GameSettings
{
    /* Members. */
    private int m_MaxPreyCount = 50;
    private int m_CurrentPreyCount = 10;
    private int m_MaxPredatorCount = 100;
    private int m_CurrentPredatorCount = 3;
    private int m_BushCount = 30;

    /* Getters/Setters. */
    public int GetMaxPreyCount() { return m_MaxPreyCount; }
    public void SetCurrentPreyCount(int value) { m_CurrentPreyCount = value; }
    public int GetCurrentPreyCount() { return m_CurrentPreyCount; }
    public int GetMaxPredatorCount() { return m_MaxPredatorCount; }
    public void SetCurrentPredatorCount(int value) { m_CurrentPredatorCount = value; }
    public int GetCurrentPredatorCount() { return m_CurrentPredatorCount; }
    public int GetBushCount() { return m_BushCount; }

    /*
     * Constructor for creating custom game settings.
    */
    public GameSettings(int maxPreyCount, int currentPreyCount, int maxPredatorCount, int currentPredatorCount, int bushCount)
    {
        m_MaxPreyCount = maxPreyCount;
        m_CurrentPreyCount = currentPreyCount;
        m_MaxPredatorCount = maxPredatorCount;
        m_CurrentPredatorCount = currentPredatorCount;
        m_BushCount = bushCount;
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
        // Set small game setting value

    }
}

public class MediumGameSettings extends GameSettings
{
    public MediumGameSettings()
    {
        // Set medium game setting value

    }
}

public class BigGameSettings extends GameSettings
{
    public BigGameSettings()
    {
        // Set big game setting value

    }
}