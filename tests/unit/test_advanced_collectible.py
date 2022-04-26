from brownie import AdvancedCollectible,network
import pytest 
from scripts.helpful_scripts import LOCAL_BLOCKCHAIN_ENVIRONMENTS, get_account,get_contract
from scripts.advanced_collectible.deploy_and_create import deploy_aand_create


def test_can_create_advanced_collectible():
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip("only for local testing")
    
    advanced_collectible,creation_transaction = deploy_aand_create()

    requestId = creation_transaction.events["requestCollectible"]['requestId']
    random_number = 777
    get_contract("vrf_coordinator").callbackWithRandomness(
        requestId,random_number,advanced_collectible.address,{"from":get_account})

    assert advanced_collectible.tokenCounter()==1
    assert advanced_collectible.tokenIdToBreed(0) == random_number % 3
