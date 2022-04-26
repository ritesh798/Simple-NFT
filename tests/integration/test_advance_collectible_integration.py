from brownie import AdvancedCollectible,network
import pytest ,time
from scripts.helpful_scripts import LOCAL_BLOCKCHAIN_ENVIRONMENTS, get_account,get_contract
from scripts.advanced_collectible.deploy_and_create import deploy_aand_create


def test_can_create_advanced_collectible_integration():
    if network.show_active()  in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip("only for integration testing")
    
    advanced_collectible,creation_transaction = deploy_aand_create()
    time.sleep(60)
    
    

    assert advanced_collectible.tokenCounter()==1
   
