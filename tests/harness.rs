use fuels::prelude::*;

abigen!(
    ExeguttorTests,
    "./amm_tests/out/debug/tests-abi.json"
);

#[tokio::test]
async fn i24_test_bits() {
    let wallet = launch_provider_and_get_wallet().await;

    let (contract_instance, _id) = get_test_contract_instance(wallet).await;

    let result = contract_instance.methods()
        .test_bits()
            .call()
            .await
            .unwrap()
            .value;

    assert!(result);
}

#[tokio::test]
async fn i24_test_indent() {
    let wallet = launch_provider_and_get_wallet().await;

    let (contract_instance, _id) = get_test_contract_instance(wallet).await;

    let result = contract_instance.methods()
        .test_indent()
            .call()
            .await
            .unwrap()
            .value;

    assert!(result);
}

#[tokio::test]
async fn i24_max_indent() {
    let wallet = launch_provider_and_get_wallet().await;

    let (contract_instance, _id) = get_test_contract_instance(wallet).await;

    let result = contract_instance.methods()
        .test_max()
            .call()
            .await
            .unwrap()
            .value;

    assert!(result);
}


async fn get_test_contract_instance(
    wallet: WalletUnlocked,
) -> (ExeguttorTests, Bech32ContractId) {
    let id = Contract::deploy(
        "./amm_tests/out/debug/tests.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::with_storage_path(Some(
            "./amm_tests/out/debug/tests-storage_slots.json"
                .to_string(),
        )),
    )
    .await
    .unwrap();

    let instance = ExeguttorTests::new(id.to_string(), wallet);

    (instance, id)
}
