# Trabajo final - Módulo-2 | Guillermo Sebastián Hidalgo Alvarado

## Descripción del contrato de KipuBank

KipuBank permite a cada usuario:

- Depositar ETH en su propia bóveda virtual.
- Retirar ETH con un límite fijo por transacción.
- Llevar un registro del número de depósitos y retiros.
- Consultar su saldo individual.

### Características:

- Límite **por cada retiro** (`withdrawalLimit`): 5 ETH (definido en el constructor como `immutable`).
- Límite **por cada depósito** (`bankCap`): 5 ETH (definido como `constant`).
- Validaciones de seguridad mediante errores personalizados (`revert` con errores).
- Uso del patrón `checks-effects-interactions` en las transferencias.
- Emisión de eventos `EthReceived` y `EthWithdrawn` para trazabilidad.

## ¿Como utilizar este contrato?

1. Ve a [Remix IDE](https://remix.ethereum.org).
2. Crea un nuevo archivo llamado `kipuBank.sol` y pega el código del contrato.
3. En la pestaña "Deploy & Run Transactions":
   - Selecciona el entorno "Injected Provider".
   - En el apartado de **At Address** ingrese la dirección del contrato.
   - Haz clic en **At Address**.
3. Una vez hecho lo anterior, verás el contrato en la sección "Deployed Contracts".

## Cómo interactuar con el contrato

### 1. Depositar ETH
Puedes depositar ETH de dos formas:
- Usando la función **deposit()** (visible en Remix):
  - En el campo "Value", escribe el monto en wei (por ejemplo, `0.1` ETH = `100000000000000000` wei).
  - Luego haz clic en `deposit()`.
- Enviando ETH directamente al contrato (esto activa la función `receive()` o `fallback()`).

El monto por depósito no debe ser mayor a **5 ETH**, de lo contrario el contrato revertirá con el error `BankCapExceeded`.

---

### 2. Retirar ETH
Usa la función **withdraw(uint256 amount)**:
- Al lado del botón de `witrdraw` ingresa la cantidad a retirar en wei. Por ejemplo: `0.5 ETH` = `500000000000000000` wei.
- Presiona el botón `withdraw`.

Condiciones para retirar:
- El monto no debe ser mayor a **5 ETH** (`withdrawalLimit`).
- Debes tener suficiente saldo en tu cuenta interna.
- Si alguna condición no se cumple, se revertirá con el error correspondiente.

---

### 3. Consultar información
- `accounts` — Devuelve el balance del usuario ingresado.
- `withdrawalCount` — Número de retiros realizados del usuario ingresado.
- `depositCount` — Número total de depósitos realizados en el contrato.
- `bankCap` — Límite de monto a depositar.
- `withdrawalLimit` — Límite del monto a retirar.