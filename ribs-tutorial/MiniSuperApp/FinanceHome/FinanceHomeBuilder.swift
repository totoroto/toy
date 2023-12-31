import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { balancedPublisher }
    private let balancedPublisher: CurrentValuePublisher<Double>
    let cardsOnFileRepository: CardOnFileRepository
    
    init(dependency: FinanceHomeDependency,
         balance: CurrentValuePublisher<Double>,
         cardsOnFileRepository: CardOnFileRepository) {
        self.balancedPublisher = balance
        self.cardsOnFileRepository = cardsOnFileRepository
        super.init(dependency: dependency)
    }
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
    let balancePublisher = CurrentValuePublisher<Double>(0)
    let component = FinanceHomeComponent(dependency: dependency,
                                         balance: balancePublisher,
                                         cardsOnFileRepository: CardOnFileRepositoryImpl())
    let viewController = FinanceHomeViewController()
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
      
      let superPayDashBoardBuilder = SuperPayDashboardBuilder(dependency: component)
      let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
      let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
      
    return FinanceHomeRouter(interactor: interactor,
                             viewController: viewController,
                             superPayDashboardBuildable: superPayDashBoardBuilder,
                             cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
                             addPaymentMethodBuildable: addPaymentMethodBuilder)
  }
}
