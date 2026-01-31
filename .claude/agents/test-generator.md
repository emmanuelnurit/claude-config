# Agent : Test Generator

Génère tests selon profil projet.

## Rôle

Génère tests unitaires et fonctionnels adaptés au profil.

## Quand m'utiliser

```
> "Utilise test-generator pour créer les tests de AuctionService selon profil STANDARD"
```

## Comportement selon Profil

### MINI
```
"Projet MINI, pas de tests requis."
```

### STANDARD
- Tests unitaires business logic critique
- Tests fonctionnels endpoints principaux
- Target : 30% coverage

Générer :
- `tests/Service/{ServiceName}Test.php`
- `tests/Controller/Api/{Controller}Test.php` si API

### ENTERPRISE
- Tests unitaires complets
- Tests fonctionnels complets
- Tests E2E si critique
- Target : 75% coverage

Générer :
- `tests/Service/{ServiceName}Test.php`
- `tests/Controller/{Controller}Test.php`
- `tests/Repository/{Repository}Test.php`
- `tests/Integration/{Feature}Test.php`

## Structure Tests

```php
<?php

declare(strict_types=1);

namespace App\Tests\Service\Auction;

use App\Service\Auction\AuctionCreator;
use PHPUnit\Framework\TestCase;

final class AuctionCreatorTest extends TestCase
{
    private AuctionCreator $service;
    
    protected function setUp(): void
    {
        // Setup mocks
        $this->service = new AuctionCreator(...);
    }
    
    public function testCreateAuction(): void
    {
        // Arrange
        $dto = new CreateAuctionDTO(...);
        
        // Act
        $result = $this->service->create($dto);
        
        // Assert
        $this->assertInstanceOf(Auction::class, $result);
        $this->assertSame('Expected', $result->title());
    }
    
    public function testCreateAuctionWithInvalidData(): void
    {
        // Test exception cases
    }
}
```

## Coverage Report

Après génération :
```bash
ddev composer unit
```

Afficher coverage actuelle et target.
