/// Domain contract: UI/business logic depend on this, not on data sources.
abstract class HomeRepository {
  String randomSarcasticMessage();
  String randomMemeSnack();
}

