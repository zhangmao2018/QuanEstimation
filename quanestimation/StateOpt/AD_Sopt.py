from julia import QuanEstimation
import quanestimation.StateOpt.StateStruct as State


class AD_Sopt(State.StateSystem):
    """
    Attributes
    ----------
    > **savefile:** `bool`
        -- Whether or not to save all the states.
        If set `True` then the states and the values of the objective function
        obtained in all episodes will be saved during the training. If set `False`
        the state in the final episode and the values of the objective function in
        all episodes will be saved.

    > **Adam:** `bool`
        -- Whether or not to use Adam for updating states.

    > **psi0:** `list of arrays`
        -- Initial guesses of states.

    > **max_episode:** `int`
        -- The number of episodes.

    > **epsilon:** `float`
        -- Learning rate.

    > **beta1:** `float`
        -- The exponential decay rate for the first moment estimates.

    > **beta2:** `float`
        -- The exponential decay rate for the second moment estimates.

    > **eps:** `float`
        -- Machine epsilon.

    > **load:** `bool`
        -- Whether or not to load states in the current location.
        If set `True` then the program will load state from "states.csv"
        file in the current location and use it as the initial state.
    """

    def __init__(
        self,
        savefile=False,
        Adam=False,
        psi0=[],
        max_episode=300,
        epsilon=0.01,
        beta1=0.90,
        beta2=0.99,
        seed=1234,
        eps=1e-8,
        load=False,
    ):

        State.StateSystem.__init__(self, savefile, psi0, seed, eps, load)

        self.Adam = Adam
        self.max_episode = max_episode
        self.epsilon = epsilon
        self.beta1 = beta1
        self.beta2 = beta2
        self.mt = 0.0
        self.vt = 0.0

        if self.Adam:
            self.alg = QuanEstimation.AD(
                self.max_episode,
                self.epsilon,
                self.beta1,
                self.beta2,
            )
        else:
            self.alg = QuanEstimation.AD(self.max_episode, self.epsilon)

    def QFIM(self, W=[], LDtype="SLD"):
        r"""
        Choose QFI or $\mathrm{Tr}(WF^{-1})$ as the objective function.
        In single parameter estimation the objective function is QFI and in
        multiparameter estimation it will be $\mathrm{Tr}(WF^{-1})$.

        Parameters
        ----------
        > **W:** `matrix`
            -- Weight matrix.

        > **LDtype:** `string`
            -- Types of QFI (QFIM) can be set as the objective function. Options are:
            "SLD" (default) -- QFI (QFIM) based on symmetric logarithmic derivative (SLD).
            "RLD" -- QFI (QFIM) based on right logarithmic derivative (RLD).
            "LLD" -- QFI (QFIM) based on left logarithmic derivative (LLD).
        """

        super().QFIM(W, LDtype)

    def CFIM(self, M=[], W=[]):
        r"""
        Choose CFI or $\mathrm{Tr}(WI^{-1})$ as the objective function.
        In single parameter estimation the objective function is CFI and
        in multiparameter estimation it will be $\mathrm{Tr}(WI^{-1})$.

        Parameters
        ----------
        > **W:** `matrix`
            -- Weight matrix.

        > **M:** `list of matrices`
            -- A set of positive operator-valued measure (POVM). The default measurement
            is a set of rank-one symmetric informationally complete POVM (SIC-POVM).

        **Note:**
            SIC-POVM is calculated by the Weyl-Heisenberg covariant SIC-POVM fiducial state
            which can be downloaded from [here](http://www.physics.umb.edu/Research/QBism/
            solutions.html).
        """

        super().CFIM(M, W)

    def HCRB(self, W=[]):
        """
        AD is not available when the objective function is HCRB.
        Supported methods are PSO, DE, DDPG and NM.

        Parameters
        ----------
        > **W:** `matrix`
            -- Weight matrix.
        """

        raise ValueError(
            "AD is not available when the objective function is HCRB. Supported methods are 'PSO', 'DE', 'NM' and 'DDPG'."
        )
